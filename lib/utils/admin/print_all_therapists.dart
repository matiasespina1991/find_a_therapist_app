import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../models/therapist_model.dart';
import '../../services/firestore_service.dart';

Future<void> printAllTherapists() async {
  try {
    FirebaseFirestore firestore = FirestoreService.instance;
    QuerySnapshot snapshot = await firestore.collection('therapists').get();
    for (var doc in snapshot.docs) {
      TherapistModel therapist = TherapistModel.fromJson(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
      log('Therapist: ${therapist.toJson()}');
    }
  } catch (e) {
    debugPrint('Failed to get therapists: $e');
  }
}
