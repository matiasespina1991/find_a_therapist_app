import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/app_settings/theme_settings.dart';
import 'package:findatherapistapp/widgets/Skeletons/SkeletonTherapistCard/skeleton_therapist_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:number_paginator/number_paginator.dart';
import '../../../models/therapist_model.dart';
import '../../../providers/providers_all.dart';
import '../../../routes/routes.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../../services/firestore_service.dart';
import '../../../widgets/TherapistListCard/therapist_list_card.dart';
import '../../common/therapist_public_profile_screen/therapist_public_profile_screen.dart';

class AllTherapistsScreen extends ConsumerStatefulWidget {
  const AllTherapistsScreen({super.key});

  @override
  ConsumerState<AllTherapistsScreen> createState() =>
      _AllTherapistsScreenState();
}

class _AllTherapistsScreenState extends ConsumerState<AllTherapistsScreen> {
  late Future<List<TherapistModel>> _futureTherapists;
  int currentPage = 0;
  late PageController _pageController;
  late NumberPaginatorController _numberPaginatorController;

  @override
  void initState() {
    super.initState();
    _futureTherapists = _fetchTherapists();
    _pageController = PageController(initialPage: currentPage);
    _numberPaginatorController = NumberPaginatorController();
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
    final isDarkMode = ref.watch(themeProvider).themeMode == ThemeMode.dark;
    return AppScaffold(
      useTopAppBar: true,
      hideFloatingSpeedDialMenu: true,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      ignoreGlobalPadding: true,
      appBarTitle: '',
      isProtected: false,
      actions: [
        /// settings button
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            context.push(Routes.settingsScreen.path);
          },
        ),
      ],
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

          int totalPages = (snapshot.data!.length / 10).ceil();

          return RefreshIndicator(
            onRefresh: _refreshTherapists,
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                        _numberPaginatorController.navigateToPage(index);
                      });
                    },
                    itemCount: totalPages,
                    itemBuilder: (context, pageIndex) {
                      final startIndex = pageIndex * 10;
                      final endIndex = (pageIndex + 1) * 10;
                      final pageItems = snapshot.data!.sublist(
                          startIndex,
                          endIndex > snapshot.data!.length
                              ? snapshot.data!.length
                              : endIndex);

                      return ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: pageItems.length,
                        itemBuilder: (context, index) {
                          final therapist = pageItems[index];
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
                      );
                    },
                  ),
                ),
                NumberPaginator(
                  config: NumberPaginatorUIConfig(
                      buttonSelectedBackgroundColor: isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade400),
                  numberPages: totalPages,
                  controller: _numberPaginatorController,
                  initialPage: currentPage,
                  onPageChange: (int index) {
                    // setState(() {
                    //   currentPage = index;
                    // });
                    _pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
