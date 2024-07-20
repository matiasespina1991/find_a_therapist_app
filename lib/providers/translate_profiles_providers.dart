// lib/providers/translate_profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:findatherapistapp/services/profiles_translate_delegate.dart';

final translateProfileProvider =
    StateNotifierProvider<TranslateProfileNotifier, bool>((ref) {
  return TranslateProfileNotifier();
});

class TranslateProfileNotifier extends StateNotifier<bool> {
  TranslateProfileNotifier() : super(false) {
    _loadTranslateProfile();
  }

  Future<void> _loadTranslateProfile() async {
    state = await ProfilesTranslateDelegate.getTranslateToUserDefinedLanguage();
  }

  Future<void> setTranslateProfile(bool value) async {
    state = value;
    await ProfilesTranslateDelegate.setTranslateToUserDefinedLanguage(value);
  }
}
