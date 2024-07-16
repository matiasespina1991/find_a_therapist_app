import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/services/gemini_service.dart';
import 'package:flutter/cupertino.dart';

import '../../models/gemini_tags_response_model.dart';
import '../../models/therapist_model.dart';
import '../../services/firestore_service.dart';

// WARNING: This function will update all therapists in the database.
Future<void> updateALLTherapistAspects() async {
  FirebaseFirestore firestore = FirestoreService.instance;
  GeminiService geminiService = GeminiService();

  // Fetch all therapists
  QuerySnapshot snapshot = await firestore.collection('therapists').get();
  List<QueryDocumentSnapshot> docs = snapshot.docs;

  for (var doc in docs) {
    try {
      var data = doc.data() as Map<String, dynamic>;

      var currentAspects = data['aspects'];
      print('Current aspects for therapist ${doc.id}: $currentAspects');

      // Remove old aspects field
      await firestore.collection('therapists').doc(doc.id).update({
        'aspects': FieldValue.delete(),
      });

      // Add empty aspects field with new structure
      await firestore.collection('therapists').doc(doc.id).update({
        'aspects': {
          'positive': [],
          'negative': [],
        },
      });

      DocumentSnapshot updatedDoc =
          await firestore.collection('therapists').doc(doc.id).get();
      data = updatedDoc.data() as Map<String, dynamic>;

      TherapistModel therapist = TherapistModel.fromJson(data, doc.id);

      String publicPresentationText =
          therapist.therapistInfo.publicPresentation ?? '';

      // Call Gemini service to get tags
      GeminiTagsResponse geminiResponseForPublicPresentation =
          await geminiService.getTherapyTags(publicPresentationText);

      if (geminiResponseForPublicPresentation.error != null) {
        debugPrint(
            'Failed to get tags for PUBLIC PRESENTATION of therapist ${therapist.id}: ${geminiResponseForPublicPresentation.error!.message}');
        continue;
      }

      String privatePresentationText =
          therapist.therapistInfo.privateNotes ?? '';

      GeminiTagsResponse geminiResponseForPrivatePresentation =
          await geminiService.getTherapyTags(privatePresentationText);

      if (geminiResponseForPrivatePresentation.error != null) {
        debugPrint(
            'Failed to get tags for PRIVATE NOTES of therapist ${therapist.id}: ${geminiResponseForPrivatePresentation.error!.message}');
        continue;
      }

      // Create lists of Term instances from the tags
      List<Term> positiveTerms = geminiResponseForPublicPresentation
          .tags.positive
          .map((tag) => Term(term: tag, public: true))
          .toList();
      List<Term> negativeTerms = geminiResponseForPublicPresentation
          .tags.negative
          .map((tag) => Term(term: tag, public: false))
          .toList();

      // Add terms from private notes
      positiveTerms.addAll(geminiResponseForPrivatePresentation.tags.positive
          .map((tag) => Term(term: tag, public: false))
          .toList());
      negativeTerms.addAll(geminiResponseForPrivatePresentation.tags.negative
          .map((tag) => Term(term: tag, public: false))
          .toList());

      Aspects newAspects = Aspects(
        positive: positiveTerms,
        negative: negativeTerms,
      );

      debugPrint(
          'New aspects for therapist ${therapist.id}: ${newAspects.toJson()}');

      await firestore.collection('therapists').doc(therapist.id).update({
        'aspects': newAspects.toJson(),
      });

      debugPrint('Updated aspects for therapist: ${therapist.id}');
    } catch (e) {
      debugPrint('Failed to update aspects for therapist ${doc.id}: $e');
    }
  }
}
