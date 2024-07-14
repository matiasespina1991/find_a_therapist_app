import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:findatherapistapp/services/firestore_service.dart';
import 'package:findatherapistapp/models/therapist_model.dart';

Future<void> findBestTherapist(Aspects userAspects) async {
  FirebaseFirestore firestore = FirestoreService.instance;

  try {
    QuerySnapshot therapistSnapshot =
        await firestore.collection('therapists').get();
    List<QueryDocumentSnapshot> therapistDocs = therapistSnapshot.docs;

    List<Map<String, dynamic>> matchScores = [];

    for (var therapistDoc in therapistDocs) {
      var therapistData = therapistDoc.data() as Map<String, dynamic>;
      TherapistModel therapist =
          TherapistModel.fromJson(therapistData, therapistDoc.id);

      int positiveMatches = 0;
      int negativeMatches = 0;

      for (var positive in userAspects.positive) {
        if (therapist.aspects.positive.contains(positive)) {
          positiveMatches++;
        }
        if (therapist.aspects.negative.contains(positive)) {
          negativeMatches++;
        }
      }

      for (var userNegativeAspect in userAspects.negative) {
        if (therapist.aspects.positive.contains(userNegativeAspect)) {
          negativeMatches++;
        }
        if (therapist.aspects.negative.contains(userNegativeAspect)) {
          negativeMatches++;
        }
      }

      int totalAspects =
          userAspects.positive.length + userAspects.negative.length;
      double matchScore = totalAspects > 0
          ? ((positiveMatches - negativeMatches) / totalAspects) * 100
          : 0.0;

      matchScores.add({
        'therapistId': therapist.id,
        'therapistName':
            '${therapist.therapistInfo.firstName} ${therapist.therapistInfo.lastName}',
        'matchScore': matchScore,
      });
    }

    matchScores.sort((a, b) => b['matchScore'].compareTo(a['matchScore']));

    for (var match in matchScores) {
      debugPrint(
          'Therapist: ${match['therapistName']}, Match Score: ${match['matchScore']}%');
    }
  } catch (e) {
    debugPrint('Failed to find best therapist: $e');
  }
}
