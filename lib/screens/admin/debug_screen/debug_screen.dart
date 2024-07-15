import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/widgets/Skeletons/SkeletonTherapistCard/skeleton_therapist_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:number_paginator/number_paginator.dart';
import '../../../models/therapist_model.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../../services/firestore_service.dart';
import '../../../widgets/TherapistListCard/therapist_list_card.dart';
import '../../common/therapist_public_profile_screen/therapist_public_profile_screen.dart';

class DebugScreen extends ConsumerStatefulWidget {
  const DebugScreen({super.key});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> {
  late Future<List<TherapistModel>> _futureTherapists;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _futureTherapists = _fetchTherapists();
  }

  Future<List<TherapistModel>> _fetchTherapists() async {
    try {
      FirebaseFirestore firestore = FirestoreService.instance;
      QuerySnapshot snapshot = await firestore.collection('therapists').get();
      return snapshot.docs.map((doc) {
        return TherapistModel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      debugPrint('Failed to get therapists: $e');
      return [];
    }
  }

  Future<void> _refreshTherapists() async {
    debugPrint('Refreshing therapists list...');
    setState(() {
      _futureTherapists = _fetchTherapists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        scrollPhysics: const NeverScrollableScrollPhysics(),
        ignoreGlobalPadding: true,
        appBarTitle: 'Debug Screen',
        isProtected: false,
        body: FutureBuilder<List<TherapistModel>>(
          future: _futureTherapists,
          builder: (context, snapshot) {
            if ((snapshot.connectionState == ConnectionState.waiting &&
                (snapshot.data == null || snapshot.data!.isEmpty))) {
              return SingleChildScrollView(
                child: Column(
                  children: List.generate(7, (index) {
                    return const SkeletonTherapistCard();
                  }),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Failed to load therapists'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No therapists found'));
            }

            return RefreshIndicator(
              onRefresh: _refreshTherapists,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final therapist = snapshot.data![index];

                        if (index < currentPage * 7 ||
                            index >= (currentPage + 1) * 7) return Container();

                        return TherapistListCard(
                          therapist: therapist,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TherapistPublicProfileScreen(
                                        therapist: therapist),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    NumberPaginator(
                      numberPages: (snapshot.data!.length / 7).ceil(),
                      onPageChange: (int index) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
