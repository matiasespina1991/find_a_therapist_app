import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../models/term_index_model.dart';
import '../../models/therapist_model.dart';
import '../../services/firestore_service.dart';

Future<void> updateTermsIndex() async {
  FirebaseFirestore firestore = FirestoreService.instance;

  // Fetch all therapists
  QuerySnapshot therapistSnapshot =
      await firestore.collection('therapists').get();
  List<QueryDocumentSnapshot> therapistDocs = therapistSnapshot.docs;

  for (var therapistDoc in therapistDocs) {
    try {
      var therapistData = therapistDoc.data() as Map<String, dynamic>;
      TherapistModel therapist =
          TherapistModel.fromJson(therapistData, therapistDoc.id);

      // Update positive aspects
      for (var positiveAspect in therapist.aspects.positive) {
        await _updateTermIndex(
            firestore, positiveAspect, therapist.id, 'positive');
      }

      // Update negative aspects
      for (var negativeAspect in therapist.aspects.negative) {
        await _updateTermIndex(
            firestore, negativeAspect, therapist.id, 'negative');
      }

      debugPrint('Updated terms index for therapist: ${therapist.id}');
    } catch (e) {
      debugPrint(
          'Failed to update terms index for therapist ${therapistDoc.id}: $e');
    }
  }
}

Future<void> _updateTermIndex(FirebaseFirestore firestore, String aspect,
    String therapistId, String aspectType) async {
  try {
    DocumentReference termRef = firestore.collection('terms-index').doc(aspect);
    DocumentSnapshot termDoc = await termRef.get();

    if (termDoc.exists) {
      TermIndex termIndex = TermIndex.fromJson(
          termDoc.data() as Map<String, dynamic>, termDoc.id);

      if (aspectType == 'positive') {
        if (!termIndex.positive
            .any((element) => element.therapistId == therapistId)) {
          termIndex.positive.add(TherapistIndex(therapistId: therapistId));
        }
      } else {
        if (!termIndex.negative
            .any((element) => element.therapistId == therapistId)) {
          termIndex.negative.add(TherapistIndex(therapistId: therapistId));
        }
      }

      await termRef.set(termIndex.toJson(), SetOptions(merge: true));
    } else {
      TermIndex termIndex = TermIndex(
        id: termDoc.id,
        term: aspect,
        associatedTerms: {
          'equivalents': [],
          'related': [],
          'subcategories': [],
        },
        positive: aspectType == 'positive'
            ? [TherapistIndex(therapistId: therapistId)]
            : [],
        negative: aspectType == 'negative'
            ? [TherapistIndex(therapistId: therapistId)]
            : [],
      );

      await termRef.set(termIndex.toJson());
    }

    debugPrint(
        'Updated term index for aspect: $aspect, therapist: $therapistId, type: $aspectType');
  } catch (e) {
    debugPrint(
        'Failed to update term index for aspect $aspect, therapist $therapistId: $e');
  }
}
