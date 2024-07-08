import 'package:flutter/cupertino.dart';

void notifyThatAppIsRunningInDebugMode() {
  debugPrint('-------------------- DEBUG MODE: ON --------------------');
  debugPrint(
      'Login screen will be skipped and user will be automatically authenticated.');
  debugPrint(
      'Change AppGeneralSettings.debugMode to false to disable this feature.');
  debugPrint('--------------------------------------------------------');
}
