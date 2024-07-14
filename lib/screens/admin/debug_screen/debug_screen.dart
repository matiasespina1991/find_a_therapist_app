import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/app_settings/theme_settings.dart';
import 'package:findatherapistapp/providers/providers_all.dart';
import 'package:findatherapistapp/utils/admin/find_best_therapist_by_aspects.dart';
import 'package:findatherapistapp/utils/admin/log_all_therapists.dart';
import 'package:findatherapistapp/widgets/Skeletons/SkeletonTherapistCard/skeleton_therapist_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/gemini_tags_response_model.dart';
import '../../../models/term_index_model.dart';
import '../../../models/therapist_model.dart';
import '../../../services/gemini_service.dart';
import '../../../utils/admin/log_all_terms.dart';
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
      scrollPhysics: NeverScrollableScrollPhysics(),
      ignoreGlobalPadding: true,
      appBarTitle: 'Debug Screen',
      isProtected: false,
      body: FutureBuilder<List<TherapistModel>>(
        future: _futureTherapists,
        builder: (context, snapshot) {
          if ((snapshot.connectionState == ConnectionState.waiting &&
                  (snapshot.data == null || snapshot.data!.isEmpty)) ||
              _futureTherapists == null) {
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
          //
          // return ElevatedButton(
          //   onPressed: () async {
          //     return logAllTherapists();
          //     // var userAspects = Aspects(
          //     //   positive: [
          //     //     'anxiety',
          //     //     'depression',
          //     //     'stress',
          //     //     'relationships',
          //     //     'self-esteem',
          //     //     'astrological-counseling',
          //     //   ],
          //     //   negative: [
          //     //     'addiction',
          //     //     'trauma',
          //     //     'grief',
          //     //     'anger',
          //     //     'eating disorders',
          //     //   ],
          //     // );
          //     // findBestTherapist(userAspects);
          //   },
          //   child: const Text('Log all therapists'),
          // );

          return RefreshIndicator(
            onRefresh: _refreshTherapists,
            child: ListView.builder(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final therapist = snapshot.data![index];

                return TherapistListCard(
                  therapist: therapist,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TherapistPublicProfileScreen(therapist: therapist),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
