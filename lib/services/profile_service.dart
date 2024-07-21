import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:findatherapistapp/utils/functions/profile_utils.dart';

final profileServiceProvider = Provider((ref) => ProfileService());

class ProfileService {
  final FirebaseFirestore _firestore = FirestoreService.instance;

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
