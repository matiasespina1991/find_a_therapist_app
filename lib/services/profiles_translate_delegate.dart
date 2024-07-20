import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilesTranslateDelegate {
  static const _storage = FlutterSecureStorage();
  static const _key = 'translate_profile_screens';

  static Future<void> setTranslateToUserDefinedLanguage(bool value) async {
    await _storage.write(key: _key, value: value.toString());
  }

  static Future<bool> getTranslateToUserDefinedLanguage() async {
    String? value = await _storage.read(key: _key);
    return value == 'true';
  }
}
