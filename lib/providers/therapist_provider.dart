import 'package:findatherapistapp/services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/therapist_model.dart';

final therapistProvider =
    StateNotifierProvider<TherapistNotifier, TherapistModel?>((ref) {
  return TherapistNotifier();
});

class TherapistNotifier extends StateNotifier<TherapistModel?> {
  TherapistNotifier() : super(null);

  Future<void> fetchTherapist(String therapistId) async {
    try {
      DocumentSnapshot doc = await FirestoreService.instance
          .collection('therapists')
          .doc(therapistId)
          .get();

      if (doc.exists) {
        state =
            TherapistModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        state = null;
      }
    } catch (e) {
      print('Error fetching therapist: $e');
      state = null;
    }
  }

  void clearTherapist() {
    state = null;
  }
}
