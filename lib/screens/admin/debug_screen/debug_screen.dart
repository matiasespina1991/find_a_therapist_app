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

          // return ElevatedButton(
          //   onPressed: () async {
          //     var userAspects = Aspects(
          //       positive: [
          //         'anxiety',
          //         'depression',
          //         'stress',
          //         'relationships',
          //         'self-esteem',
          //         'astrological-counseling',
          //       ],
          //       negative: [
          //         'addiction',
          //         'trauma',
          //         'grief',
          //         'anger',
          //         'eating disorders',
          //       ],
          //     );
          //     findBestTherapist(userAspects);
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

                var theme = ref.watch(themeProvider);

                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: ThemeSettings.cardVerticalSpacing,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.themeMode == ThemeMode.dark
                        ? Colors.grey[900]
                        : Colors.white,
                    boxShadow: [
                      if (theme.themeMode == ThemeMode.light)
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          blurRadius: 5,
                          offset: const Offset(1, 2),
                        ),
                    ],
                    borderRadius: ThemeSettings.cardBorderRadius,
                    border: BoxBorder.lerp(
                      Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 0.5,
                      ),
                      Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 0.5,
                      ),
                      0.5,
                    ),
                  ),
                  foregroundDecoration: BoxDecoration(
                    borderRadius: ThemeSettings.cardBorderRadius,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        ThemeSettings.seedColor.withOpacity(0.01),
                      ],
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: ThemeSettings.cardBorderRadius,
                      onTap: () {},
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 1,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(2),
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          therapist.therapistInfo
                                              .profilePictureUrl.small,
                                        ),
                                      ),
                                    ),
                                    if (therapist.isOnline)
                                      Positioned(
                                        bottom: 1.5,
                                        right: 2,
                                        child: Card(
                                          elevation: 0.5,
                                          child: Container(
                                            width: 17,
                                            height: 17,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: therapist.isOnline
                                                  ? Colors.green
                                                  : Colors.red,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              '${therapist.therapistInfo.firstName} ${therapist.therapistInfo.lastName}',
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          if (therapist
                                              .therapistInfo.userInfoIsVerified)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              child:
                                                  therapist.subscription.plan ==
                                                          'gold'
                                                      ? Image.asset(
                                                          'lib/assets/icons/gold-plan-badge.png',
                                                          width: 15,
                                                        )
                                                      : Image.asset(
                                                          'lib/assets/icons/verified-badge.png',
                                                          width: 15,
                                                        ),
                                            ),
                                        ],
                                      ),
                                      Text(
                                        '${therapist.therapistInfo.location.city}, ${therapist.therapistInfo.location.country}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      Text(
                                        therapist.therapistInfo.bio,
                                        style: TextStyle(
                                          fontSize: 15.5,
                                          color: Colors.grey[700],
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: 7,
                              right: 15,
                              child: Row(
                                children: [
                                  Text('${therapist.score.rating}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      )),
                                  const SizedBox(width: 3),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
