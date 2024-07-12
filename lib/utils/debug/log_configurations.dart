import 'package:findatherapistapp/app_settings/app_general_settings.dart';
import 'package:flutter/cupertino.dart';

import 'notify_that_app_is_runing_in_debug_mode.dart';

logConfigurations() {
  if (DebugConfig.debugMode) {
    debugPrint('-- DEBUG MODE IS ON --');
  }
  if (DebugConfig.bypassLoginScreen) {
    notifyThatLoginScreenIsBeingSkipped();
  }
}
