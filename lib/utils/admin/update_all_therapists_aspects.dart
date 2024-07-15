import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/services/gemini_service.dart';
import 'package:flutter/cupertino.dart';

import '../../models/gemini_tags_response_model.dart';
import '../../models/therapist_model.dart';
import '../../services/firestore_service.dart';

//WARNING: This function will update all therapists in the database.
Future<void> updateALLTherapistAspects() async {
  FirebaseFirestore firestore = FirestoreService.instance;
  GeminiService geminiService = GeminiService();

  // Fetch all therapists
  QuerySnapshot snapshot = await firestore.collection('therapists').get();
  List<QueryDocumentSnapshot> docs = snapshot.docs;

  for (var doc in docs) {
    try {
      var data = doc.data() as Map<String, dynamic>;
      TherapistModel therapist = TherapistModel.fromJson(data, doc.id);

      String combinedText = '${therapist.therapistInfo.publicPresentation ?? ''} ${therapist.therapistInfo.privateNotes ?? ''}';

      // Call Gemini service to get tags
      GeminiTagsResponse geminiResponse =
          await geminiService.getTherapyTags(combinedText);

      if (geminiResponse.error != null) {
        debugPrint(
            'Failed to get tags for therapist ${therapist.id}: ${geminiResponse.error!.message}');
        continue;
      }

      Aspects newAspects = Aspects(
        positive: geminiResponse.tags.positive,
        negative: geminiResponse.tags.negative,
      );

      // print('New aspects: ${newAspects.toJson()}');

      await firestore.collection('therapists').doc(therapist.id).update({
        'aspects': newAspects.toJson(),
      });

      debugPrint('Updated aspects for therapist: ${therapist.id}');
    } catch (e) {
      debugPrint('Failed to update aspects for therapist ${doc.id}: $e');
    }
  }
}
