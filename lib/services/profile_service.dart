import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:findatherapistapp/utils/functions/profile_utils.dart';

import '../models/therapist_model.dart';

final profileServiceProvider = Provider((ref) => ProfileService());

class ProfileService {
  final FirebaseFirestore _firestore = FirestoreService.instance;

  Future<void> updateTermIndexForTherapist(String therapistId,
      List<Term> positiveTerms, List<Term> negativeTerms) async {
    FirebaseFirestore firestore = FirestoreService.instance;

    Future<void> _addTherapistToTerm(
        DocumentSnapshot termDoc, String therapistId, String aspectType) async {
      Map<String, dynamic> termData = termDoc.data() as Map<String, dynamic>;
      List<Map<String, dynamic>> updatedPositive =
          List<Map<String, dynamic>>.from(termData['positive'] ?? []);
      List<Map<String, dynamic>> updatedNegative =
          List<Map<String, dynamic>>.from(termData['negative'] ?? []);

      if (aspectType == 'positive') {
        // Add therapistId to positive and remove from negative if exists
        if (!updatedPositive
            .any((element) => element['therapistId'] == therapistId)) {
          updatedPositive.add({'therapistId': therapistId});
        }
        updatedNegative
            .removeWhere((element) => element['therapistId'] == therapistId);
      } else {
        // Add therapistId to negative and remove from positive if exists
        if (!updatedNegative
            .any((element) => element['therapistId'] == therapistId)) {
          updatedNegative.add({'therapistId': therapistId});
        }
        updatedPositive
            .removeWhere((element) => element['therapistId'] == therapistId);
      }

      await termDoc.reference.update({
        'positive': updatedPositive,
        'negative': updatedNegative,
      });
    }

    Future<void> _updateTerm(
        String term, String therapistId, String aspectType) async {
      DocumentReference termRef = firestore.collection('terms-index').doc(term);
      DocumentSnapshot termDoc = await termRef.get();

      if (termDoc.exists) {
        await _addTherapistToTerm(termDoc, therapistId, aspectType);
      } else {
        debugPrint('Term "$term" does not exist. Checking equivalents...');
        QuerySnapshot equivalentTermsSnapshot = await firestore
            .collection('terms-index')
            .where('associatedTerms.equivalents', arrayContains: term)
            .get();

        if (equivalentTermsSnapshot.docs.isNotEmpty) {
          for (var equivalentTermDoc in equivalentTermsSnapshot.docs) {
            debugPrint('Equivalent term found: ${equivalentTermDoc.id}');
            await _addTherapistToTerm(
                equivalentTermDoc, therapistId, aspectType);
          }
        } else {
          debugPrint(
              'No equivalents found for term "$term". Creating new term...');
          await termRef.set({
            'term': term,
            'associatedTerms': {
              'equivalents': [],
              'related': [],
              'subcategories': [],
            },
            'positive': aspectType == 'positive'
                ? [
                    {'therapistId': therapistId}
                  ]
                : [],
            'negative': aspectType == 'negative'
                ? [
                    {'therapistId': therapistId}
                  ]
                : [],
          });
        }
      }
    }

    try {
      for (var term in positiveTerms) {
        await _updateTerm(term.term, therapistId, 'positive');
      }

      for (var term in negativeTerms) {
        await _updateTerm(term.term, therapistId, 'negative');
      }

      debugPrint('Term-index updated successfully for therapist $therapistId');
    } catch (e) {
      debugPrint('Error updating term-index for therapist $therapistId: $e');
    }
  }

  Future<bool> updateTherapistAspects(
      {required String userId, required Map<String, dynamic> data}) async {
    bool success = true;
    try {
      /// make aspects.negative empty array in database
      await _firestore
          .collection('therapists')
          .doc(userId)
          .update({'aspects.negative': []});
      await _firestore
          .collection('therapists')
          .doc(userId)
          .update({'aspects.positive': []});
      debugPrint('Previews therapist aspects cleared successfully.');

      await _firestore.collection('therapists').doc(userId).update(data);
      debugPrint('Therapist aspects updated successfully.');
      return success;
    } catch (e) {
      debugPrint('Error updating therapist aspects: $e');
      success = false;

      return success;
    }
  }

  Future<bool> updateProfile({
    required String profileTarget,
    required String userId,
    required Map<String, dynamic> data,
    File? profilePicture,
  }) async {
    bool success = true;
    try {
      if (profilePicture != null) {
        final downloadUrl =
            await uploadProfilePicture(profilePicture, profileTarget);
        if (downloadUrl != null) {
          data['therapistInfo']['profilePictureUrl'] = {
            'large': downloadUrl,
            'small': '',
            'thumb': ''
          };
        }
      }
      await _firestore
          .collection(profileTarget == 'therapist' ? 'therapists' : 'users')
          .doc(userId)
          .update(data);
      debugPrint('Profile updated successfully.');
      return success;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      success = false;

      return success;
    }
  }
}
