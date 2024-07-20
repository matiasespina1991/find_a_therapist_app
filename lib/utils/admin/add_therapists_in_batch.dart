import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/services/firestore_service.dart';
import '../../models/therapist_model.dart';

Future<void> addTherapistsBatch(List<TherapistModel> therapists) async {
  FirebaseFirestore firestore = FirestoreService.instance;
  WriteBatch batch = firestore.batch();

  /// Comment this line to allow this function to run
  return;
  try {
    for (var therapist in therapists) {
      DocumentReference docRef = firestore.collection('therapists').doc();
      batch.set(docRef, therapist.toJson());
    }
    await batch.commit();
    print('Therapists added successfully');
  } catch (e) {
    print('Failed to add therapists: $e');
  }
}
