import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/app_settings/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/therapist_model.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../../services/firestore_service.dart';

class DebugScreen extends ConsumerStatefulWidget {
  const DebugScreen({super.key});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> {
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

  // Future<void> addMockTherapists() async {
  //   List<Map<String, dynamic>> mockTherapistsList = [
  //     {
  //       "createdAt": Timestamp.fromDate(DateTime(2023, 5, 12)),
  //       "updatedAt": Timestamp.fromDate(DateTime(2024, 1, 10)),
  //       "aspects": {
  //         "positive": ["stress", "relationships"],
  //         "negative": ["addiction"]
  //       },
  //       "subscription": {
  //         "endsAt": Timestamp.fromDate(DateTime(2024, 5, 12)),
  //         "plan": "gold",
  //         "startedAt": Timestamp.fromDate(DateTime(2023, 5, 12)),
  //         "autoRenewal": true
  //       },
  //       "score": {"rating": 4.9, "amountRatings": 200},
  //       "isOnline": true,
  //       "therapistInfo": {
  //         "bio":
  //             "Therapist with extensive experience in stress and relationship counseling.",
  //         "location": {
  //           "address": "123 Therapy Lane",
  //           "city": "Buenos Aires",
  //           "country": "AR",
  //           "geolocation": GeoPoint(-34.603722, -58.381592),
  //           "stateProvince": "Buenos Aires",
  //           "zip": "1000"
  //         },
  //         "firstName": "Sofia",
  //         "userInfoIsVerified": true,
  //         "lastName": "Rodriguez Vaccaro",
  //         "specializations": ["therapist", "counselor"],
  //         "spokenLanguages": ["es", "en"],
  //         "professionalCertificates": [
  //           {
  //             "yearObtained": 2015,
  //             "photoUrl": "https://example.com/certificate.jpg",
  //             "title": "Masters in Clinical Psychology",
  //             "type": "master",
  //             "institution": "University of Buenos Aires",
  //             "verified": true
  //           }
  //         ],
  //         "profilePictureUrl": {
  //           "large": "https://randomuser.me/api/portraits/women/12.jpg",
  //           "small": "https://randomuser.me/api/portraits/women/12.jpg",
  //           "thumb": "https://randomuser.me/api/portraits/women/12.jpg"
  //         }
  //       }
  //     }
  //   ];
  //
  //   FirebaseFirestore firestore = FirestoreService.instance;
  //
  //   try {
  //     WriteBatch batch = firestore.batch();
  //     for (var therapistData in mockTherapistsList) {
  //       DocumentReference docRef = firestore.collection('therapists').doc();
  //       String id = docRef.id;
  //
  //       TherapistModel therapist = TherapistModel.fromJson(therapistData, id);
  //
  //       batch.set(docRef, therapist.toJson());
  //     }
  //     await batch.commit();
  //     debugPrint('Mock therapists added successfully.');
  //   } catch (e) {
  //     debugPrint('Failed to add mock therapists: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: 'Debug Screen',
      isProtected: false,
      body: FutureBuilder<List<TherapistModel>>(
        future: _fetchTherapists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load therapists'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No therapists found'));
          }

          // return ElevatedButton(
          //     onPressed: () {
          //       addMockTherapists();
          //     },
          //     child: Text('Add isOnline field'));

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              final therapist = snapshot.data![index];

              return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: const EdgeInsets.symmetric(
                  vertical: ThemeSettings.cardVerticalSpacing,
                  horizontal: 0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2.5,
                child: InkWell(
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
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: CachedNetworkImageProvider(
                                      therapist.therapistInfo.profilePictureUrl
                                          .small,
                                    ),
                                  ),
                                ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: therapist.subscription.plan ==
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
              );
            },
          );
        },
      ),
    );
  }
}
