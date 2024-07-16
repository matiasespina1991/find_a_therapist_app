import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:findatherapistapp/models/therapist_model.dart';
import 'package:findatherapistapp/models/term_index_model.dart';

Future<List<Map<String, dynamic>>> findBestTherapist(Aspects userAspects,
    {String version = '3'}) async {
  FirebaseFirestore firestore = FirestoreService.instance;
  CollectionReference termsCollection = firestore.collection('terms-index');
  CollectionReference therapistsCollection = firestore.collection('therapists');

  Map<String, double> therapistScores = {};
  int totalAspects = userAspects.positive.length + userAspects.negative.length;

  try {
    for (var positive in userAspects.positive) {
      List<String> relatedTerms = await getRelatedTerms(positive.term, version);

      for (var term in relatedTerms) {
        DocumentSnapshot termDoc = await termsCollection.doc(term).get();

        if (termDoc.exists) {
          TermIndex termIndex = TermIndex.fromJson(
              termDoc.data() as Map<String, dynamic>, termDoc.id);

          for (var therapist in termIndex.positive) {
            therapistScores.update(
                therapist.therapistId,
                (score) =>
                    score +
                    (term == positive.term
                        ? 1 / totalAspects * 100
                        : (relatedTerms.contains(term)
                            ? 0.5 / totalAspects * 100
                            : 0.0)),
                ifAbsent: () => (term == positive.term
                    ? 1 / totalAspects * 100
                    : (relatedTerms.contains(term)
                        ? 0.5 / totalAspects * 100
                        : 0.0)));
          }

          for (var therapist in termIndex.negative) {
            therapistScores.update(
                therapist.therapistId,
                (score) =>
                    score -
                    (term == positive.term
                        ? 1 / totalAspects * 100
                        : (relatedTerms.contains(term)
                            ? 0.5 / totalAspects * 100
                            : 0.0)),
                ifAbsent: () => -(term == positive.term
                    ? 1 / totalAspects * 100
                    : (relatedTerms.contains(term)
                        ? 0.5 / totalAspects * 100
                        : 0.0)));
          }
        }
      }
    }

    for (var negative in userAspects.negative) {
      List<String> relatedTerms = await getRelatedTerms(negative.term, version);

      for (var term in relatedTerms) {
        DocumentSnapshot termDoc = await termsCollection.doc(term).get();

        if (termDoc.exists) {
          TermIndex termIndex = TermIndex.fromJson(
              termDoc.data() as Map<String, dynamic>, termDoc.id);

          for (var therapist in termIndex.positive) {
            therapistScores.update(
                therapist.therapistId,
                (score) =>
                    score -
                    (term == negative.term
                        ? 1 / totalAspects * 100
                        : (relatedTerms.contains(term)
                            ? 0.5 / totalAspects * 100
                            : 0.0)),
                ifAbsent: () => -(term == negative.term
                    ? 1 / totalAspects * 100
                    : (relatedTerms.contains(term)
                        ? 0.5 / totalAspects * 100
                        : 0.0)));
          }

          for (var therapist in termIndex.negative) {
            therapistScores.update(
                therapist.therapistId,
                (score) =>
                    score +
                    (term == negative.term
                        ? 1 / totalAspects * 100
                        : (relatedTerms.contains(term)
                            ? 0.5 / totalAspects * 100
                            : 0.0)),
                ifAbsent: () => (term == negative.term
                    ? 1 / totalAspects * 100
                    : (relatedTerms.contains(term)
                        ? 0.5 / totalAspects * 100
                        : 0.0)));
          }
        }
      }
    }

    List<Map<String, dynamic>> matchScores = therapistScores.entries
        .map((entry) => {
              'therapistId': entry.key,
              'matchScore': entry.value.clamp(0.0, 100.0)
            })
        .toList();

    matchScores.sort((a, b) => b['matchScore'].compareTo(a['matchScore']));

    List<Map<String, dynamic>> finalResults = [];

    for (var match in matchScores) {
      DocumentSnapshot therapistDoc =
          await therapistsCollection.doc(match['therapistId']).get();
      if (therapistDoc.exists) {
        TherapistModel therapist = TherapistModel.fromJson(
            therapistDoc.data() as Map<String, dynamic>, therapistDoc.id);
        finalResults.add({
          'therapist': therapist,
          'matchScore': match['matchScore'],
        });
      }
    }

    return finalResults;
  } catch (e) {
    debugPrint('Failed to find best therapist: $e');
    return [];
  }
}

Future<List<String>> getRelatedTerms(String term, String version) async {
  FirebaseFirestore firestore = FirestoreService.instance;
  CollectionReference termsCollection = firestore.collection('terms-index');

  DocumentSnapshot termDoc = await termsCollection.doc(term).get();

  if (termDoc.exists) {
    TermIndex termIndex =
        TermIndex.fromJson(termDoc.data() as Map<String, dynamic>, termDoc.id);

    List<String> relatedTerms = [termIndex.term];
    if (version == '2' || version == '3') {
      if (termIndex.associatedTerms.containsKey('equivalents')) {
        relatedTerms.addAll(termIndex.associatedTerms['equivalents']!);
      }
    }
    if (version == '3') {
      if (termIndex.associatedTerms.containsKey('subcategories')) {
        relatedTerms.addAll(termIndex.associatedTerms['subcategories']!);
      }

      // Add parent terms if the current term is a subcategory
      QuerySnapshot parentSnapshot = await termsCollection
          .where('associatedTerms.subcategories', arrayContains: term)
          .get();
      for (var parentDoc in parentSnapshot.docs) {
        relatedTerms.add(parentDoc.id);
      }
    }
    return relatedTerms;
  } else {
    return [term];
  }
}
