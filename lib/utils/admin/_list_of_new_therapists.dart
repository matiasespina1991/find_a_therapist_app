// List<TherapistModel> therapists = [
//   TherapistModel(
//     id: '',
//     createdAt: Timestamp.now(),
//     updatedAt: Timestamp.now(),
//     aspects: Aspects(
//       positive: [
//         'pet-therapy',
//         'animal-assisted-therapy',
//         'companion-animals',
//         'emotional-support-animals',
//         'well-being',
//         'stress-relief',
//         'emotional-support'
//       ],
//       negative: ['severe-allergies'],
//     ),
//     subscription: Subscription(
//       endsAt: Timestamp.fromDate(DateTime.now()
//           .add(const Duration(days: 365))),
//       plan: 'gold',
//       startedAt: Timestamp.now(),
//       autoRenewal: true,
//     ),
//     score: Score(rating: 4.9, amountRatings: 150),
//     therapistInfo: TherapistInfo(
//       bio:
//       'Specialist in pet therapy and animal-assisted therapy.',
//       publicPresentation:
//       'Hello, I am Laura Davies, a therapist specializing in pet therapy and animal-assisted therapy. I help clients experience the therapeutic benefits of interacting with companion animals to improve their emotional well-being and reduce stress.',
//       privateNotes:
//       'Prefers not to work with clients who have severe allergies to animals.',
//       location: Location(
//         address: '123 Animal Therapy Lane',
//         city: 'Petville',
//         country: 'Animaria',
//         geolocation: const GeoPoint(40.7128, -74.0060),
//         stateProvince: 'Animalia',
//         zip: '12345',
//       ),
//       firstName: 'Laura',
//       userInfoIsVerified: true,
//       lastName: 'Davies',
//       specializations: ['animal therapist'],
//       spokenLanguages: ['en'],
//       professionalCertificates: [
//         ProfessionalCertificate(
//           institution: 'University of Animal Therapy',
//           photoUrl:
//           'https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png',
//           title: 'Masters in Animal Therapy',
//           type: 'master',
//           verified: true,
//           yearObtained: 2015,
//         ),
//       ],
//       profilePictureUrl: ProfilePictureUrl(
//         large:
//         'https://randomuser.me/api/portraits/women/12.jpg',
//         small:
//         'https://randomuser.me/api/portraits/women/12.jpg',
//         thumb:
//         'https://randomuser.me/api/portraits/women/12.jpg',
//       ),
//       meetingType: MeetingType(
//           presential: true, remote: false),
//     ),
//     isOnline: true,
//   ),
//   TherapistModel(
//     id: '',
//     createdAt: Timestamp.now(),
//     updatedAt: Timestamp.now(),
//     aspects: Aspects(
//       positive: [
//         'art-therapy',
//         'creative-expression',
//         'healing-through-art',
//         'self-discovery',
//         'emotional-expression',
//         'creative-healing',
//         'artistic-techniques'
//       ],
//       negative: ['non-creative-approaches'],
//     ),
//     subscription: Subscription(
//       endsAt: Timestamp.fromDate(DateTime.now()
//           .add(const Duration(days: 365))),
//       plan: 'gold',
//       startedAt: Timestamp.now(),
//       autoRenewal: true,
//     ),
//     score: Score(rating: 4.8, amountRatings: 120),
//     therapistInfo: TherapistInfo(
//       bio:
//       'Expert in art therapy and creative expression.',
//       publicPresentation:
//       'Hi, I am Samuel Turner, an expert in art therapy and creative expression. My sessions encourage clients to explore their emotions and heal through artistic techniques and creative expression.',
//       privateNotes:
//       'Prefers clients who are open to creative approaches.',
//       location: Location(
//         address: '456 Creative Path',
//         city: 'Artville',
//         country: 'Creativia',
//         geolocation: const GeoPoint(34.0522, -118.2437),
//         stateProvince: 'Creativland',
//         zip: '67890',
//       ),
//       firstName: 'Samuel',
//       userInfoIsVerified: true,
//       lastName: 'Turner',
//       specializations: ['art therapist'],
//       spokenLanguages: ['en'],
//       professionalCertificates: [
//         ProfessionalCertificate(
//           institution: 'Art Therapy Institute',
//           photoUrl:
//           'https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png',
//           title: 'Masters in Art Therapy',
//           type: 'master',
//           verified: true,
//           yearObtained: 2014,
//         ),
//       ],
//       profilePictureUrl: ProfilePictureUrl(
//         large:
//         'https://randomuser.me/api/portraits/men/13.jpg',
//         small:
//         'https://randomuser.me/api/portraits/men/13.jpg',
//         thumb:
//         'https://randomuser.me/api/portraits/men/13.jpg',
//       ),
//       meetingType:
//       MeetingType(presential: true, remote: true),
//     ),
//     isOnline: true,
//   ),
//   TherapistModel(
//     id: '',
//     createdAt: Timestamp.now(),
//     updatedAt: Timestamp.now(),
//     aspects: Aspects(
//       positive: [
//         'music-therapy',
//         'healing-with-music',
//         'emotional-expression',
//         'musical-creativity',
//         'therapeutic-music-sessions',
//         'self-discovery',
//         'stress-relief'
//       ],
//       negative: ['non-musical-approaches'],
//     ),
//     subscription: Subscription(
//       endsAt: Timestamp.fromDate(DateTime.now()
//           .add(const Duration(days: 365))),
//       plan: 'gold',
//       startedAt: Timestamp.now(),
//       autoRenewal: true,
//     ),
//     score: Score(rating: 4.7, amountRatings: 110),
//     therapistInfo: TherapistInfo(
//       bio:
//       'Music therapist specializing in emotional healing through music.',
//       publicPresentation:
//       'Hello, I am Isabel Flores, a music therapist specializing in emotional healing through music. I use musical creativity and therapeutic music sessions to help clients express their emotions and find relief from stress.',
//       privateNotes:
//       'Focuses on clients who are open to musical therapy.',
//       location: Location(
//         address: '789 Harmony Blvd',
//         city: 'Musicville',
//         country: 'Melodia',
//         geolocation: const GeoPoint(51.5074, -0.1278),
//         stateProvince: 'Harmoniland',
//         zip: '98765',
//       ),
//       firstName: 'Isabel',
//       userInfoIsVerified: true,
//       lastName: 'Flores',
//       specializations: ['music therapist'],
//       spokenLanguages: ['en', 'es'],
//       professionalCertificates: [
//         ProfessionalCertificate(
//           institution: 'Music Therapy University',
//           photoUrl:
//           'https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png',
//           title: 'Masters in Music Therapy',
//           type: 'master',
//           verified: true,
//           yearObtained: 2016,
//         ),
//       ],
//       profilePictureUrl: ProfilePictureUrl(
//         large:
//         'https://randomuser.me/api/portraits/women/14.jpg',
//         small:
//         'https://randomuser.me/api/portraits/women/14.jpg',
//         thumb:
//         'https://randomuser.me/api/portraits/women/14.jpg',
//       ),
//       meetingType:
//       MeetingType(presential: true, remote: true),
//     ),
//     isOnline: true,
//   ),
//   TherapistModel(
//     id: '',
//     createdAt: Timestamp.now(),
//     updatedAt: Timestamp.now(),
//     aspects: Aspects(
//       positive: [
//         'sports-therapy',
//         'athletic-performance',
//         'injury-rehabilitation',
//         'mental-toughness',
//         'stress-management',
//         'goal-setting',
//         'physical-fitness'
//       ],
//       negative: ['non-athletic-issues'],
//     ),
//     subscription: Subscription(
//       endsAt: Timestamp.fromDate(DateTime.now()
//           .add(const Duration(days: 365))),
//       plan: 'gold',
//       startedAt: Timestamp.now(),
//       autoRenewal: true,
//     ),
//     score: Score(rating: 4.9, amountRatings: 130),
//     therapistInfo: TherapistInfo(
//       bio:
//       'Sports therapist specializing in mental and physical well-being for athletes.',
//       publicPresentation:
//       'Hi, I am Diego Rodriguez, a sports therapist specializing in the mental and physical well-being of athletes. I focus on enhancing athletic performance, injury rehabilitation, and mental toughness.',
//       privateNotes:
//       'Works primarily with athletes and individuals involved in sports.',
//       location: Location(
//         address: '101 Fitness Way',
//         city: 'Athletica',
//         country: 'Sportland',
//         geolocation: const GeoPoint(48.8566, 2.3522),
//         stateProvince: 'Fitland',
//         zip: '54321',
//       ),
//       firstName: 'Diego',
//       userInfoIsVerified: true,
//       lastName: 'Rodriguez',
//       specializations: ['sports therapist'],
//       spokenLanguages: ['en', 'es'],
//       professionalCertificates: [
//         ProfessionalCertificate(
//           institution: 'Sports Therapy Academy',
//           photoUrl:
//           'https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png',
//           title: 'Masters in Sports Therapy',
//           type: 'master',
//           verified: true,
//           yearObtained: 2013,
//         ),
//       ],
//       profilePictureUrl: ProfilePictureUrl(
//         large:
//         'https://randomuser.me/api/portraits/men/15.jpg',
//         small:
//         'https://randomuser.me/api/portraits/men/15.jpg',
//         thumb:
//         'https://randomuser.me/api/portraits/men/15.jpg',
//       ),
//       meetingType: MeetingType(
//           presential: true, remote: false),
//     ),
//     isOnline: true,
//   ),
//   TherapistModel(
//     id: '',
//     createdAt: Timestamp.now(),
//     updatedAt: Timestamp.now(),
//     aspects: Aspects(
//       positive: [
//         'nutrition-therapy',
//         'diet-planning',
//         'holistic-health',
//         'weight-management',
//         'nutritional-counseling',
//         'healthy-eating',
//         'lifestyle-changes'
//       ],
//       negative: ['fad-diets'],
//     ),
//     subscription: Subscription(
//       endsAt: Timestamp.fromDate(DateTime.now()
//           .add(const Duration(days: 365))),
//       plan: 'gold',
//       startedAt: Timestamp.now(),
//       autoRenewal: true,
//     ),
//     score: Score(rating: 4.8, amountRatings: 140),
//     therapistInfo: TherapistInfo(
//       bio:
//       'Nutrition therapist focusing on holistic health and diet planning.',
//       publicPresentation:
//       'Hello, I am Clara Kim, a nutrition therapist focusing on holistic health and diet planning. I provide nutritional counseling and support for clients aiming to achieve their health goals through healthy eating and lifestyle changes.',
//       privateNotes:
//       'Avoids working with clients seeking quick-fix fad diets.',
//       location: Location(
//         address: '202 Health St',
//         city: 'Nutritia',
//         country: 'Healthland',
//         geolocation: const GeoPoint(35.6895, 139.6917),
//         stateProvince: 'Wellnessland',
//         zip: '11223',
//       ),
//       firstName: 'Clara',
//       userInfoIsVerified: true,
//       lastName: 'Kim',
//       specializations: ['nutrition therapist'],
//       spokenLanguages: ['en', 'ko'],
//       professionalCertificates: [
//         ProfessionalCertificate(
//           institution: 'Nutrition Therapy University',
//           photoUrl:
//           'https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png',
//           title: 'Masters in Nutrition Therapy',
//           type: 'master',
//           verified: true,
//           yearObtained: 2018,
//         ),
//       ],
//       profilePictureUrl: ProfilePictureUrl(
//         large:
//         'https://randomuser.me/api/portraits/women/16.jpg',
//         small:
//         'https://randomuser.me/api/portraits/women/16.jpg',
//         thumb:
//         'https://randomuser.me/api/portraits/women/16.jpg',
//       ),
//       meetingType:
//       MeetingType(presential: true, remote: true),
//     ),
//     isOnline: true,
//   ),
//   TherapistModel(
//     id: '',
//     createdAt: Timestamp.now(),
//     updatedAt: Timestamp.now(),
//     aspects: Aspects(
//       positive: [
//         'tech-therapy',
//         'digital-detox',
//         'screen-time-management',
//         'tech-addiction',
//         'digital-well-being',
//         'healthy-tech-use',
//         'cyber-wellness'
//       ],
//       negative: ['non-tech-related-issues'],
//     ),
//     subscription: Subscription(
//       endsAt: Timestamp.fromDate(DateTime.now()
//           .add(const Duration(days: 365))),
//       plan: 'gold',
//       startedAt: Timestamp.now(),
//       autoRenewal: true,
//     ),
//     score: Score(rating: 4.7, amountRatings: 90),
//     therapistInfo: TherapistInfo(
//       bio:
//       'Tech therapist specializing in digital well-being and tech addiction.',
//       publicPresentation:
//       'Hi, I am Michael Lee, a tech therapist specializing in digital well-being and tech addiction. I help clients manage their screen time, undergo digital detox, and develop healthy tech use habits.',
//       privateNotes:
//       'Focuses on clients with tech-related issues and addictions.',
//       location: Location(
//         address: '303 Tech Therapy Ave',
//         city: 'Cyberville',
//         country: 'Technologia',
//         geolocation: const GeoPoint(37.7749, -122.4194),
//         stateProvince: 'Technoland',
//         zip: '33445',
//       ),
//       firstName: 'Michael',
//       userInfoIsVerified: true,
//       lastName: 'Lee',
//       specializations: ['tech therapist'],
//       spokenLanguages: ['en'],
//       professionalCertificates: [
//         ProfessionalCertificate(
//           institution: 'Tech Therapy Institute',
//           photoUrl:
//           'https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png',
//           title: 'Masters in Tech Therapy',
//           type: 'master',
//           verified: true,
//           yearObtained: 2017,
//         ),
//       ],
//       profilePictureUrl: ProfilePictureUrl(
//         large:
//         'https://randomuser.me/api/portraits/men/17.jpg',
//         small:
//         'https://randomuser.me/api/portraits/men/17.jpg',
//         thumb:
//         'https://randomuser.me/api/portraits/men/17.jpg',
//       ),
//       meetingType:
//       MeetingType(presential: true, remote: true),
//     ),
//     isOnline: true,
//   ),
//   TherapistModel(
//     id: '',
//     createdAt: Timestamp.now(),
//     updatedAt: Timestamp.now(),
//     aspects: Aspects(
//       positive: [
//         'dance-therapy',
//         'movement-therapy',
//         'expressive-dance',
//         'emotional-release',
//         'physical-expression',
//         'dance-as-healing',
//         'body-awareness'
//       ],
//       negative: ['non-expressive-approaches'],
//     ),
//     subscription: Subscription(
//       endsAt: Timestamp.fromDate(DateTime.now()
//           .add(const Duration(days: 365))),
//       plan: 'gold',
//       startedAt: Timestamp.now(),
//       autoRenewal: true,
//     ),
//     score: Score(rating: 4.9, amountRatings: 100),
//     therapistInfo: TherapistInfo(
//       bio:
//       'Dance therapist focusing on emotional and physical expression through movement.',
//       publicPresentation:
//       'Hello, I am Emily Chen, a dance therapist focusing on emotional and physical expression through movement. I use dance as a healing tool to help clients achieve emotional release and body awareness.',
//       privateNotes:
//       'Works primarily with clients who are open to expressive dance therapy.',
//       location: Location(
//         address: '404 Movement Rd',
//         city: 'Dancetown',
//         country: 'Rhythmland',
//         geolocation: const GeoPoint(45.4215, -75.6972),
//         stateProvince: 'Expressland',
//         zip: '55667',
//       ),
//       firstName: 'Emily',
//       userInfoIsVerified: true,
//       lastName: 'Chen',
//       specializations: ['dance therapist'],
//       spokenLanguages: ['en', 'zh'],
//       professionalCertificates: [
//         ProfessionalCertificate(
//           institution: 'Dance Therapy Academy',
//           photoUrl:
//           'https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png',
//           title: 'Masters in Dance Therapy',
//           type: 'master',
//           verified: true,
//           yearObtained: 2012,
//         ),
//       ],
//       profilePictureUrl: ProfilePictureUrl(
//         large:
//         'https://randomuser.me/api/portraits/women/18.jpg',
//         small:
//         'https://randomuser.me/api/portraits/women/18.jpg',
//         thumb:
//         'https://randomuser.me/api/portraits/women/18.jpg',
//       ),
//       meetingType:
//       MeetingType(presential: true, remote: true),
//     ),
//     isOnline: true,
//   ),
//   TherapistModel(
//     id: '',
//     createdAt: Timestamp.now(),
//     updatedAt: Timestamp.now(),
//     aspects: Aspects(
//       positive: [
//         'eco-therapy',
//         'nature-therapy',
//         'environmental-therapy',
//         'outdoor-healing',
//         'nature-connection',
//         'forest-bathing',
//         'environmental-well-being'
//       ],
//       negative: ['indoor-therapy'],
//     ),
//     subscription: Subscription(
//       endsAt: Timestamp.fromDate(DateTime.now()
//           .add(const Duration(days: 365))),
//       plan: 'gold',
//       startedAt: Timestamp.now(),
//       autoRenewal: true,
//     ),
//     score: Score(rating: 4.8, amountRatings: 85),
//     therapistInfo: TherapistInfo(
//       bio:
//       'Eco-therapist focusing on healing through nature and environmental connection.',
//       publicPresentation:
//       'Hi, I am Daniel Green, an eco-therapist focusing on healing through nature and environmental connection. My sessions involve outdoor activities and nature immersion to promote well-being and mental health.',
//       privateNotes:
//       'Prefers clients who enjoy outdoor therapy and nature-based healing.',
//       location: Location(
//         address: '505 Nature Trail',
//         city: 'Greenville',
//         country: 'Ecotopia',
//         geolocation: const GeoPoint(40.7128, -74.0060),
//         stateProvince: 'Forestland',
//         zip: '77889',
//       ),
//       firstName: 'Daniel',
//       userInfoIsVerified: true,
//       lastName: 'Green',
//       specializations: ['eco therapist'],
//       spokenLanguages: ['en'],
//       professionalCertificates: [
//         ProfessionalCertificate(
//           institution: 'Eco Therapy Institute',
//           photoUrl:
//           'https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png',
//           title: 'Masters in Eco Therapy',
//           type: 'master',
//           verified: true,
//           yearObtained: 2019,
//         ),
//       ],
//       profilePictureUrl: ProfilePictureUrl(
//         large:
//         'https://randomuser.me/api/portraits/men/19.jpg',
//         small:
//         'https://randomuser.me/api/portraits/men/19.jpg',
//         thumb:
//         'https://randomuser.me/api/portraits/men/19.jpg',
//       ),
//       meetingType: MeetingType(
//           presential: true, remote: false),
//     ),
//     isOnline: true,
//   ),
//   TherapistModel(
//     id: '',
//     createdAt: Timestamp.now(),
//     updatedAt: Timestamp.now(),
//     aspects: Aspects(
//       positive: [
//         'play-therapy',
//         'child-therapy',
//         'emotional-expression',
//         'creative-play',
//         'behavioral-issues',
//         'child-development',
//         'supportive-environment'
//       ],
//       negative: ['non-child-related-issues'],
//     ),
//     subscription: Subscription(
//       endsAt: Timestamp.fromDate(DateTime.now()
//           .add(const Duration(days: 365))),
//       plan: 'gold',
//       startedAt: Timestamp.now(),
//       autoRenewal: true,
//     ),
//     score: Score(rating: 4.7, amountRatings: 95),
//     therapistInfo: TherapistInfo(
//       bio:
//       'Play therapist specializing in child development and emotional expression.',
//       publicPresentation:
//       'Hello, I am Sara Ahmed, a play therapist specializing in child development and emotional expression. I use creative play to help children express their emotions and work through behavioral issues in a supportive environment.',
//       privateNotes:
//       'Focuses on working with children and their families.',
//       location: Location(
//         address: '606 Play Therapy Lane',
//         city: 'Childville',
//         country: 'Kidland',
//         geolocation: const GeoPoint(41.9028, 12.4964),
//         stateProvince: 'Playland',
//         zip: '88990',
//       ),
//       firstName: 'Sara',
//       userInfoIsVerified: true,
//       lastName: 'Ahmed',
//       specializations: ['play therapist'],
//       spokenLanguages: ['en', 'ar'],
//       professionalCertificates: [
//         ProfessionalCertificate(
//           institution: 'Play Therapy Institute',
//           photoUrl:
//           'https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png',
//           title: 'Masters in Play Therapy',
//           type: 'master',
//           verified: true,
//           yearObtained: 2014,
//         ),
//       ],
//       profilePictureUrl: ProfilePictureUrl(
//         large:
//         'https://randomuser.me/api/portraits/women/20.jpg',
//         small:
//         'https://randomuser.me/api/portraits/women/20.jpg',
//         thumb:
//         'https://randomuser.me/api/portraits/women/20.jpg',
//       ),
//       meetingType:
//       MeetingType(presential: true, remote: true),
//     ),
//     isOnline: true,
//   ),
//   TherapistModel(
//     id: '',
//     createdAt: Timestamp.now(),
//     updatedAt: Timestamp.now(),
//     aspects: Aspects(
//       positive: [
//         'mindfulness-therapy',
//         'meditation',
//         'stress-reduction',
//         'mental-clarity',
//         'emotional-balance',
//         'mindful-living',
//         'holistic-approach'
//       ],
//       negative: ['non-mindful-approaches'],
//     ),
//     subscription: Subscription(
//       endsAt: Timestamp.fromDate(DateTime.now()
//           .add(const Duration(days: 365))),
//       plan: 'gold',
//       startedAt: Timestamp.now(),
//       autoRenewal: true,
//     ),
//     score: Score(rating: 4.9, amountRatings: 130),
//     therapistInfo: TherapistInfo(
//       bio:
//       'Mindfulness therapist focusing on meditation and stress reduction.',
//       publicPresentation:
//       'Hi, I am Asha Patel, a mindfulness therapist focusing on meditation and stress reduction. My sessions help clients achieve mental clarity and emotional balance through mindful living and holistic approaches.',
//       privateNotes:
//       'Prefers clients who are open to mindfulness and meditation practices.',
//       location: Location(
//         address: '707 Zen Lane',
//         city: 'Mindfulcity',
//         country: 'Calmness',
//         geolocation: const GeoPoint(19.0760, 72.8777),
//         stateProvince: 'Peacefulstate',
//         zip: '99001',
//       ),
//       firstName: 'Asha',
//       userInfoIsVerified: true,
//       lastName: 'Patel',
//       specializations: ['mindfulness therapist'],
//       spokenLanguages: ['en', 'hi'],
//       professionalCertificates: [
//         ProfessionalCertificate(
//           institution:
//           'Mindfulness Therapy University',
//           photoUrl:
//           'https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png',
//           title: 'Masters in Mindfulness Therapy',
//           type: 'master',
//           verified: true,
//           yearObtained: 2015,
//         ),
//       ],
//       profilePictureUrl: ProfilePictureUrl(
//         large:
//         'https://randomuser.me/api/portraits/women/21.jpg',
//         small:
//         'https://randomuser.me/api/portraits/women/21.jpg',
//         thumb:
//         'https://randomuser.me/api/portraits/women/21.jpg',
//       ),
//       meetingType:
//       MeetingType(presential: true, remote: true),
//     ),
//     isOnline: true,
//   ),
// ];
//
// addTherapistsBatch(therapists);
