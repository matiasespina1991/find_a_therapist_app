import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final therapistsLanguagesProvider =
    ChangeNotifierProvider((ref) => TherapistsLanguagesProvider());

class TherapistsLanguagesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirestoreService.instance;
  List<String> _languages = [];

  List<String> get languages => _languages;

  TherapistsLanguagesProvider() {
    _fetchLanguages();
  }

  Future<void> _fetchLanguages() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collectionGroup('therapists')
          .where('therapistInfo.spokenLanguages', isNull: false)
          .get();

      Set<String> languageSet = {};

      for (var doc in querySnapshot.docs) {
        List<dynamic> spokenLanguages = doc['therapistInfo']['spokenLanguages'];
        languageSet.addAll(spokenLanguages.cast<String>());
      }

      _languages = languageSet.toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching languages: $e");
    }
  }
}
