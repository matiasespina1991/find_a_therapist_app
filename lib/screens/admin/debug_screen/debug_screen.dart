import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../../services/firestore_service.dart';

class DebugScreen extends ConsumerStatefulWidget {
  const DebugScreen({super.key});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> {
  Future<void> _printAllTerms() async {
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

  Future<void> _printAllTherapists() async {
    try {
      FirebaseFirestore firestore = FirestoreService.instance;
      QuerySnapshot snapshot = await firestore.collection('therapists').get();
      for (var doc in snapshot.docs) {
        debugPrint('Therapist: ${doc.data()}');
      }
    } catch (e) {
      debugPrint('Failed to get therapists: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: 'Debug Screen',
      isProtected: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _printAllTerms,
              child: const Text('Print all terms'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _printAllTherapists,
              child: const Text('Print all therapists'),
            ),
          ],
        ),
      ),
    );
  }
}
