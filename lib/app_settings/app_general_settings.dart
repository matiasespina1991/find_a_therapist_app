class AppGeneralSettings {
  static const bool useTopAppBar = false;
  static const bool useFloatingSpeedDialMenu = true;
  static const bool useAppDrawerMenu = false;
  static const String minimumiOSVersion =
      '13.0'; // Set this manually in Xcode & Podfile
  static const String minimumAndroidVersion =
      '23'; // Set this manually in android/app/build.gradle
}

class DebugConfig {
  static const bool debugMode = false; // If true, login screen will be skipped
  static const String debugScreen = '/home'; //TODO
}
