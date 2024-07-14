import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:findatherapistapp/services/firestore_service.dart';
import 'package:findatherapistapp/models/therapist_model.dart';

import '../../models/term_index_model.dart';

Future<List<Map<String, dynamic>>> findBestTherapist(
    Aspects userAspects) async {
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
        List<String> relatedTerms = await getRelatedTerms(positive);
        for (var term in relatedTerms) {
          if (therapist.aspects.positive.contains(term)) {
            positiveMatches++;
            if (term == positive) {
              positiveMatches++; // Extra point for exact match
            }
          }
          if (therapist.aspects.negative.contains(term)) {
            negativeMatches++;
          }
        }
      }

      for (var userNegativeAspect in userAspects.negative) {
        List<String> relatedTerms = await getRelatedTerms(userNegativeAspect);
        for (var term in relatedTerms) {
          if (therapist.aspects.positive.contains(term)) {
            negativeMatches++;
          }
          if (therapist.aspects.negative.contains(term)) {
            negativeMatches++;
          }
        }
      }

      int totalAspects =
          userAspects.positive.length + userAspects.negative.length;
      double matchScore = totalAspects > 0
          ? ((positiveMatches - negativeMatches) / totalAspects) * 100
          : 0.0;

      matchScores.add({
        'therapist': therapist,
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

    return matchScores;
  } catch (e) {
    debugPrint('Failed to find best therapist: $e');
    return [];
  }
}

Future<List<String>> getRelatedTerms(String term) async {
  FirebaseFirestore firestore = FirestoreService.instance;
  CollectionReference termsCollection = firestore.collection('terms-index');

  DocumentSnapshot termDoc = await termsCollection.doc(term).get();

  if (termDoc.exists) {
    TermIndex termIndex =
        TermIndex.fromJson(termDoc.data() as Map<String, dynamic>, termDoc.id);

    List<String> relatedTerms = [termIndex.term];
    if (termIndex.associatedTerms.containsKey('subcategories')) {
      relatedTerms.addAll(termIndex.associatedTerms['subcategories']!);
    }
    if (termIndex.associatedTerms.containsKey('equivalents')) {
      relatedTerms.addAll(termIndex.associatedTerms['equivalents']!);
    }
    return relatedTerms;
  } else {
    return [term];
  }
}
