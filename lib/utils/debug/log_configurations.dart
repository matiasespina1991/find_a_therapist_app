import 'package:find_a_therapist_app/app_settings/app_general_settings.dart';

import 'notify_that_app_is_runing_in_debug_mode.dart';

logConfigurations() {
  if (DebugConfig.debugMode) {
    notifyThatAppIsRunningInDebugMode();
  }
}
