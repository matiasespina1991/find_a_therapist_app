import '../routes/routes.dart';

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
  static const bool debugMode = true;
  static const String debugDatabaseId = 'debug-database';
  static const bool showDebugPrints = false;
  static RouteConfig debugScreen = Routes.therapistProfileScreen;
  static const forceDebugScreen =
      true; // If true, the route set in debugScreen will be shown and screen protection will be ignored
  static const bool bypassLoginScreen =
      false; // If true, login screen will be skipped
  // static const bool alwaysAllowNavigation =
  //     true;
}
