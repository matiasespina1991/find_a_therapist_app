import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<void> _printAllTerms() async {
    try {
      FirebaseFirestore firestore = FirestoreService.instance;
      QuerySnapshot snapshot = await firestore.collection('terms-index').get();
      for (var doc in snapshot.docs) {
        debugPrint('Term: ${doc.data()}');
      }
    } catch (e) {
      debugPrint('Failed to get terms: $e');
    }
  }

  void updateTherapistPresentations() async {
    List<Map<String, dynamic>> therapists = [
      {
        "id": "700MaDcTvn73yrXyaozx",
        "publicPresentation":
            "Hello, I am Vernon Washington, an experienced psychologist specializing in cognitive behavioral therapy. With over two decades of experience, I have dedicated my career to helping individuals overcome depression and various mental health challenges. My therapeutic approach is grounded in evidence-based practices, focusing on understanding and reshaping negative thought patterns to foster mental well-being. I believe in creating a supportive and empathetic environment where clients feel safe to explore their thoughts and emotions. My goal is to empower clients to achieve lasting positive changes and lead fulfilling lives.",
        "privateNotes":
            "Prefers not to work with patients with bipolar disorder. Interested in working with young adults and professionals facing stress and anxiety. Tailors approach to individual needs, focusing on cognitive and behavioral strategies."
      },
      {
        "id": "AhCRJehRbnT2gPdH3KJb",
        "publicPresentation":
            "Hello, I am Sofia Rodriguez Vaccaro, an astrologist with extensive experience in astrological counseling. My practice is dedicated to providing clients with profound insights and guidance through personalized astrological readings. Understanding one’s astrological chart can offer valuable perspectives on life paths, relationships, and personal growth. I strive to create a space where clients feel empowered to make informed decisions and embrace their true selves. My approach is both compassionate and intuitive, combining ancient wisdom with modern insights.",
        "privateNotes":
            "Avoids discussing controversial topics. Prefers clients who are open to non-traditional methods and have a genuine interest in astrology. Not interested in working with those who seek quick fixes or are skeptical of astrology."
      },
      {
        "id": "DtNSKLyb0fTPNuyOBZv6",
        "publicPresentation":
            "Hi, I am Leah Weaver, a psychologist specializing in family therapy and child psychology. My work is centered on supporting families and children through various challenges, fostering healthy relationships, and promoting psychological well-being. I use a holistic approach that incorporates play therapy, cognitive-behavioral techniques, and family counseling to address the unique needs of each client. My goal is to create a nurturing environment where families can thrive and children can develop resilience and emotional intelligence.",
        "privateNotes":
            "Prefers not to work with addiction cases. Enjoys working with children under 12 years old and their families. Focuses on family dynamics and uses play therapy extensively. Prefers clients who are committed to long-term therapy."
      },
      {
        "id": "LR4YUCvcPvGwx3QsYzf4",
        "publicPresentation":
            "Hello, I am Ashley Willis, a psychologist specializing in family therapy and child psychology. My practice focuses on helping families navigate through life’s challenges and supporting children in their emotional and psychological development. With a compassionate and individualized approach, I aim to foster healthy family dynamics and promote positive growth in children. I utilize evidence-based techniques to address issues such as behavioral problems, anxiety, and developmental concerns. My goal is to empower families to build strong, supportive relationships and help children achieve their full potential.",
        "privateNotes":
            "Prefers not to work with bipolar disorder cases. Interested in helping families with young children and addressing early developmental issues. Utilizes a combination of family therapy and individual child sessions."
      },
      {
        "id": "O1pik0KI6mERRnOkkcdL",
        "publicPresentation":
            "Hi, I am Parsa Parsa, a psychologist specializing in cognitive behavioral therapy. With years of experience, I am dedicated to helping individuals manage and overcome depression and other mental health challenges. My approach involves identifying and changing negative thought patterns and behaviors to improve emotional well-being. I strive to create a therapeutic environment that is supportive, understanding, and empowering for my clients. Together, we work towards achieving mental clarity, resilience, and personal growth.",
        "privateNotes":
            "Prefers not to work with severe bipolar disorder cases. Focuses on helping clients with mild to moderate depression and anxiety. Interested in working with young adults and professionals facing workplace stress. Utilizes a structured, goal-oriented approach."
      },
      {
        "id": "TMuT2FyYKQcGRvcklMTv",
        "publicPresentation":
            "Hello, I am Derrick Reid, a specialist in cognitive behavioral therapy and treating depression. With extensive experience in the field, I am committed to helping individuals overcome their mental health challenges and achieve emotional well-being. My therapeutic approach is centered around evidence-based practices that focus on understanding and modifying negative thought patterns. I strive to provide a supportive and empathetic environment where clients can feel safe to explore their thoughts and emotions. My goal is to empower individuals to make lasting positive changes in their lives.",
        "privateNotes":
            "Prefers not to work with severe bipolar disorder cases. Interested in working with individuals experiencing mild to moderate depression. Utilizes a combination of cognitive-behavioral techniques and mindfulness practices."
      },
      {
        "id": "XAMGFHAFl92MWS3AwE8Y",
        "publicPresentation":
            "Hi, I am Brooklyn Smith, a specialist in treating anxiety and depression. With a deep understanding of these conditions, I am dedicated to helping individuals manage their symptoms and improve their quality of life. My approach involves a combination of cognitive-behavioral techniques and mindfulness practices to address the unique needs of each client. I believe in creating a safe and supportive environment where clients can feel comfortable exploring their thoughts and emotions. Together, we work towards achieving mental clarity, emotional balance, and overall well-being.",
        "privateNotes":
            "Prefers not to work with phobia cases. Focuses on helping clients with anxiety and depression. Interested in working with adults and young adults facing life transitions and stress. Utilizes a holistic approach that includes lifestyle changes and coping strategies."
      },
      {
        "id": "axThabqGviHrQr8DRsjJ",
        "publicPresentation":
            "Hello, I am Nehrika Vernekar, an experienced psychologist specializing in anxiety management. With a strong background in psychology, I am committed to helping individuals overcome anxiety and related challenges. My therapeutic approach combines cognitive-behavioral techniques with mindfulness practices to help clients develop effective coping strategies. I believe in providing a compassionate and understanding environment where clients can feel safe to explore their thoughts and emotions. My goal is to empower individuals to achieve mental clarity, emotional balance, and overall well-being.",
        "privateNotes":
            "Prefers not to work with Jungian or eating disorder cases. Interested in working with clients experiencing anxiety and depression. Utilizes a combination of cognitive-behavioral techniques and mindfulness practices."
      },
      {
        "id": "bA9epYfv26AOb9UCrAwg",
        "publicPresentation":
            "Hi, I am Mahya Neko Nazari, a psychologist specializing in adolescent therapy. With a focus on supporting teenagers through their developmental years, I aim to help them navigate the challenges they face. My approach involves a combination of behavioral therapy and counseling techniques to address issues such as anxiety, depression, and behavioral problems. I believe in creating a safe and supportive environment where adolescents can feel comfortable discussing their thoughts and feelings. My goal is to empower them to develop resilience and achieve emotional well-being.",
        "privateNotes":
            "Prefers not to work with addiction cases. Focuses on helping adolescents with anxiety, depression, and behavioral issues. Utilizes a combination of behavioral therapy and counseling techniques. Interested in working with families to support the adolescent's development."
      },
      {
        "id": "bRmtCt2UfvtyAONXGSUB",
        "publicPresentation":
            "Hello, I am Mathias Guerin, specializing in trauma recovery and post-traumatic growth. With extensive experience in clinical psychology, I am dedicated to helping individuals heal from trauma and achieve personal growth. My approach involves evidence-based practices that focus on understanding and processing traumatic experiences. I strive to create a supportive and empathetic environment where clients can feel safe to explore their emotions. My goal is to empower individuals to overcome their past and build a fulfilling future.",
        "privateNotes":
            "Prefers not to work with addiction cases. Interested in working with individuals who have experienced trauma. Utilizes a combination of cognitive-behavioral techniques and trauma-focused therapies. Focuses on helping clients achieve post-traumatic growth."
      },
      {
        "id": "cVuBkkeQXxSnZVSYCIig",
        "publicPresentation":
            "Hi, I am Ondriy Sirchenko, a therapist with a focus on trauma and recovery. With a deep understanding of trauma and its effects, I am committed to helping individuals heal and find strength in their recovery journey. My approach involves a combination of cognitive-behavioral techniques and trauma-focused therapies to address the unique needs of each client. I believe in creating a safe and supportive environment where clients can feel comfortable exploring their emotions. Together, we work towards achieving emotional balance, resilience, and overall well-being.",
        "privateNotes":
            "Prefers not to work with Jungian or eating disorder cases. Interested in working with clients who have experienced trauma. Utilizes a combination of cognitive-behavioral techniques and trauma-focused therapies."
      },
      {
        "id": "cpS4KVgMUUamzFhgtDDb",
        "publicPresentation":
            "Hello, I am Molina Rezaiyan, a psychologist specializing in family therapy and child psychology. With a focus on supporting families through their challenges, I aim to foster healthy relationships and promote psychological well-being. My approach involves a combination of family therapy and individual child sessions to address the unique needs of each client. I believe in creating a nurturing environment where families can thrive and children can develop resilience and emotional intelligence. My goal is to empower families to build strong, supportive relationships.",
        "privateNotes":
            "Prefers not to work with bipolar disorder cases. Interested in helping families with young children and addressing early developmental issues. Utilizes a combination of family therapy and individual child sessions."
      },
      {
        "id": "ezNlNEfOoxc0hr1YhPyZ",
        "publicPresentation":
            "Hi, I am Vildan Evliyaoğlu, a therapist with a focus on cultural and societal issues. With extensive experience in social work, I am dedicated to helping individuals navigate the complexities of cultural and societal dynamics. My approach involves a combination of cultural therapy and counseling techniques to address issues such as identity, belonging, and societal pressures. I believe in creating a safe and understanding environment where clients can feel comfortable discussing their experiences. My goal is to empower individuals to embrace their cultural identity and achieve personal growth.",
        "privateNotes":
            "Prefers not to work with bipolar disorder cases. Interested in helping clients with cultural and societal issues. Utilizes a combination of cultural therapy and counseling techniques."
      },
      {
        "id": "mWvwsxX8vmd7aXIR4JsZ",
        "publicPresentation":
            "Hello, I am Nellie Nelson, a geriatric therapist specializing in family therapy. With a focus on supporting elderly individuals and their families, I aim to help them navigate the challenges of aging. My approach involves a combination of geriatric therapy and family counseling to address issues such as loneliness, grief, and family dynamics. I believe in creating a compassionate and understanding environment where clients can feel comfortable discussing their thoughts and feelings. My goal is to empower elderly individuals to maintain their mental well-being and strengthen family relationships.",
        "privateNotes":
            "Prefers not to work with eating disorder cases. Interested in working with elderly individuals and their families. Utilizes a combination of geriatric therapy and family counseling."
      },
      {
        "id": "np5eeWL9323WDw91BWJk",
        "publicPresentation":
            "Hi, I am Lucas Byrd, a veteran therapist with over 40 years of experience. Specializing in cognitive behavioral therapy, I am dedicated to helping individuals overcome their mental health challenges. My approach involves identifying and modifying negative thought patterns and behaviors to improve emotional well-being. I strive to create a supportive and empathetic environment where clients can feel comfortable exploring their thoughts and emotions. My goal is to empower individuals to achieve mental clarity, resilience, and overall well-being.",
        "privateNotes":
            "Prefers not to work with schizophrenia cases. Interested in helping clients with cognitive behavioral therapy. Focuses on helping individuals with mild to moderate depression and anxiety."
      },
      {
        "id": "zTuB4K8ZerUVGRqPUHr3",
        "publicPresentation":
            "Hello, I am Elena Sultani Nejad, a therapist specializing in anxiety and depression. With a strong background in counseling, I am committed to helping individuals manage their symptoms and achieve emotional well-being. My approach involves a combination of cognitive-behavioral techniques and mindfulness practices to address the unique needs of each client. I believe in creating a safe and supportive environment where clients can feel comfortable exploring their thoughts and emotions. Together, we work towards achieving mental clarity, emotional balance, and overall well-being.",
        "privateNotes":
            "Prefers not to work with phobia cases. Focuses on helping clients with anxiety and depression. Interested in working with adults and young adults facing life transitions and stress. Utilizes a holistic approach that includes lifestyle changes and coping strategies."
      }
    ];
    debugPrint('Updating therapists...');
    try {
      for (var therapist in therapists) {
        debugPrint('Updating therapist: ${therapist['id']}');

        FirebaseFirestore firestore = FirestoreService.instance;
        var therap = firestore.collection('therapists').doc(therapist['id']);
        await therap.update({
          'therapistInfo.publicPresentation': therapist['publicPresentation'],
          'therapistInfo.privateNotes': therapist['privateNotes'],
        });
      }
      debugPrint('Therapists updated successfully');
    } catch (e) {
      debugPrint('Failed to update therapists: $e');
    }
  }

  Future<void> _printAllTherapists() async {
    try {
      FirebaseFirestore firestore = FirestoreService.instance;
      QuerySnapshot snapshot = await firestore.collection('therapists').get();
      for (var doc in snapshot.docs) {
        TherapistModel therapist = TherapistModel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
        log('Therapist: $therapist');
      }
    } catch (e) {
      debugPrint('Failed to get therapists: $e');
    }
  }

  Future<void> _addMockTherapists() async {
    List<Map<String, dynamic>> mockTherapistsList = [
      {
        "createdAt": Timestamp.fromDate(DateTime(2023, 5, 12)),
        "updatedAt": Timestamp.fromDate(DateTime(2024, 1, 10)),
        "isOnline": true,
        "aspects": {
          "positive": ["stress", "relationships"],
          "negative": ["addiction"]
        },
        "subscription": {
          "endsAt": Timestamp.fromDate(DateTime(2024, 5, 12)),
          "plan": "gold",
          "startedAt": Timestamp.fromDate(DateTime(2023, 5, 12)),
          "autoRenewal": true
        },
        "score": {"rating": 4.9, "amountRatings": 200},
        "therapistInfo": {
          "bio":
              "Therapist with extensive experience in stress and relationship counseling.",
          "location": {
            "address": "123 Therapy Lane",
            "city": "Buenos Aires",
            "country": "AR",
            "geolocation": const GeoPoint(-34.603722, -58.381592),
            "stateProvince": "Buenos Aires",
            "zip": "1000"
          },
          "firstName": "Sofia",
          "userInfoIsVerified": true,
          "lastName": "Rodriguez Vaccaro",
          "specializations": ["therapist", "counselor"],
          "spokenLanguages": ["es", "en"],
          "professionalCertificates": [
            {
              "yearObtained": 2015,
              "photoUrl": "https://example.com/certificate.jpg",
              "title": "Masters in Clinical Psychology",
              "type": "master",
              "institution": "University of Buenos Aires",
              "verified": true
            }
          ],
          "profilePictureUrl": {
            "large": "https://randomuser.me/api/portraits/women/12.jpg",
            "small": "https://randomuser.me/api/portraits/women/12.jpg",
            "thumb": "https://randomuser.me/api/portraits/women/12.jpg"
          }
        }
      }
    ];

    FirebaseFirestore firestore = FirestoreService.instance;

    try {
      WriteBatch batch = firestore.batch();
      for (var therapistData in mockTherapistsList) {
        DocumentReference docRef = firestore.collection('therapists').doc();
        String id = docRef.id;

        TherapistModel therapist = TherapistModel.fromJson(therapistData, id);

        batch.set(docRef, therapist.toJson());
      }
      await batch.commit();
      debugPrint('Mock therapists added successfully.');
    } catch (e) {
      debugPrint('Failed to add mock therapists: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: 'Debug Screen',
      isProtected: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _printAllTerms,
              child: const Text('Print all terms'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _printAllTherapists,
              child: const Text('Print all therapists'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMockTherapists,
              child: const Text('Add Mock Therapists'),
            ),
          ],
        ),
      ),
    );
  }
}
