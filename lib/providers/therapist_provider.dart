import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/therapist_model.dart';
import '../services/firestore_service.dart';

class TherapistState {
  final TherapistModel? therapist;
  final bool isLoading;

  TherapistState({this.therapist, this.isLoading = false});
}

final therapistProvider =
    StateNotifierProvider<TherapistNotifier, TherapistState>((ref) {
  return TherapistNotifier();
});

class TherapistNotifier extends StateNotifier<TherapistState> {
  TherapistNotifier() : super(TherapistState());

  Future<void> fetchTherapist(String therapistId) async {
    state = TherapistState(isLoading: true);
    try {
      DocumentSnapshot doc = await FirestoreService.instance
          .collection('therapists')
          .doc(therapistId)
          .get();

      if (doc.exists) {
        state = TherapistState(
          therapist: TherapistModel.fromJson(
              doc.data() as Map<String, dynamic>, doc.id),
          isLoading: false,
        );
      } else {
        state = TherapistState(isLoading: false);
      }
    } catch (e) {
      state = TherapistState(isLoading: false);
    }
  }

  void clearTherapist() {
    state = TherapistState();
  }
}
