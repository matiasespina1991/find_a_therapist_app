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
            "geolocation": GeoPoint(-34.603722, -58.381592),
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
