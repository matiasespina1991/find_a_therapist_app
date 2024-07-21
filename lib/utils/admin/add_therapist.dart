// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:findatherapistapp/services/firestore_service.dart';
//
// import '../../models/therapist_model.dart';
//
// Future<void> addTherapist({TherapistModel? therapist}) async {
//   final TherapistModel bestTherapistForJohnDoe = TherapistModel(
//     createdAt: Timestamp.now(),
//     updatedAt: Timestamp.now(),
//     aspects: Aspects(
//       positive: [
//         Term(term: 'black', public: true),
//         Term(term: 'cultural-background', public: true),
//         Term(term: 'racial-trauma', public: true),
//         Term(term: 'anxiety', public: true),
//         Term(term: 'low-self-esteem', public: true),
//         Term(term: 'trust-issues', public: true),
//         Term(term: 'depression', public: true),
//         Term(term: 'loneliness', public: true),
//         Term(term: 'work-stress', public: true),
//         Term(term: 'burnout', public: true),
//         Term(term: 'insomnia', public: true),
//         Term(term: 'body-image-issues', public: true),
//         Term(term: 'disordered-eating', public: true),
//         Term(term: 'social-anxiety', public: true),
//         Term(term: 'jungian-analysis', public: true),
//         Term(term: 'astrology', public: true),
//         Term(term: 'holistic-healing', public: true),
//         Term(term: 'spirituality', public: true),
//       ],
//       negative: [
//         Term(term: 'cbt', public: false),
//         Term(term: 'psychiatrist', public: false),
//         Term(term: 'psychoanalysis', public: false),
//         Term(term: 'freudian-theories', public: false),
//         Term(term: 'clinical-impersonal-approach', public: false),
//       ],
//     ),
//     subscription: Subscription(
//       endsAt: Timestamp.fromDate(DateTime.now().add(const Duration(days: 365))),
//       plan: 'gold',
//       startedAt: Timestamp.now(),
//       autoRenewal: true,
//     ),
//     score: Score(rating: 4.8, amountRatings: 120),
//     therapistInfo: TherapistInfo(
//         intro:
//             'Experienced black therapist specializing in culturally sensitive therapy.',
//         publicPresentation:
//             'As an experienced black therapist, I am deeply committed to providing culturally sensitive therapy that addresses the unique challenges faced by individuals from diverse backgrounds. I specialize in helping clients navigate the complexities of anxiety, low self-esteem, and trust issues arising from experiences of racial discrimination and microaggressions. My goal is to create a safe and supportive environment where clients feel understood and empowered to overcome these challenges.My expertise extends to addressing issues such as depression, loneliness, work-related stress, burnout, insomnia, body image issues, disordered eating, and social anxiety. I offer compassionate support and effective strategies to manage these feelings, helping clients develop a healthy work-life balance and a positive self-perception. Additionally, I incorporate elements of spirituality, holistic healing, and Jungian analysis into therapy, recognizing the importance of addressing the whole person—mind, body, and spirit.I avoid rigid and impersonal therapeutic methods such as cognitive-behavioral therapy (CBT), medication-based treatments, traditional psychoanalysis, and Freudian theories. Instead, I provide a personalized and empathetic therapeutic relationship, ensuring that each client receives the most appropriate and effective care for their unique circumstances. My practice is designed to be a safe haven where clients can explore their spirituality, engage in holistic healing, and find meaning in their experiences.',
//         privateNotes: '',
//         location: Location(
//           address: '123 Therapy Lane',
//           city: 'Berlin',
//           country: 'Germany',
//           geolocation: const GeoPoint(52.5200, 13.4050),
//           stateProvince: 'Berlin',
//           zip: '10115',
//         ),
//         firstName: 'Jane',
//         userInfoIsVerified: true,
//         lastName: 'Smith',
//         specializations: ['racial-trauma', 'anxiety', 'depression'],
//         spokenLanguages: ['en', 'de'],
//         professionalCertificates: [
//           ProfessionalCertificate(
//             institution: 'University of Berlin',
//             photoUrl:
//                 'https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png',
//             title: 'Psychology PhD',
//             type: 'Doctorate',
//             verified: true,
//             yearObtained: 2010,
//           ),
//         ],
//         profilePictureUrl: ProfilePictureUrl(
//           large: 'https://randomuser.me/api/portraits/women/6.jpg',
//           small: 'https://randomuser.me/api/portraits/women/6.jpg',
//           thumb: 'https://randomuser.me/api/portraits/women/6.jpg',
//         ),
//         meetingType: MeetingType(presential: true, remote: true)),
//     isOnline: true,
//     id: '',
//   );
//
//   print(
//       'Adding therapist: ${bestTherapistForJohnDoe.therapistInfo.firstName} ${bestTherapistForJohnDoe.therapistInfo.lastName}');
//
//   therapist = bestTherapistForJohnDoe;
//   try {
//     FirebaseFirestore firestore = FirestoreService.instance;
//     print('Firestore instance created');
//
//     var therapist = await firestore
//         .collection('therapists')
//         .add(bestTherapistForJohnDoe.toJson());
//     print('Therapist ID: ${therapist.id}');
//     print('Therapist added successfully');
//   } catch (e) {
//     print('Failed to add therapist: $e');
//   }
// }
