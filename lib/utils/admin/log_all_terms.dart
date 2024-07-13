import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../services/firestore_service.dart';

Future<void> logAllTerms() async {
  try {
    FirebaseFirestore firestore = FirestoreService.instance;
    QuerySnapshot snapshot = await firestore.collection('terms-index').get();
    for (var doc in snapshot.docs) {
      debugPrint('Term: ${doc.data()}');
    }
  } catch (e) {
    debugPrint('Failed to get terms: $e');
  }
}
