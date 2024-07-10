import 'package:flutter/cupertino.dart';

void notifyThatLoginScreenIsBeingSkipped() {
  debugPrint(
      '-------------------- BYPASS LOGIN SCREEN: ON --------------------');
  debugPrint(
      'Login screen will be skipped and user will be automatically authenticated.');
  debugPrint(
      'Change AppGeneralSettings.bypassLoginScreen to false to disable this feature.');
  debugPrint('--------------------------------------------------------');
}
