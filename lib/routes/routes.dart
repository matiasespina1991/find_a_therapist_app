import 'package:findatherapistapp/app_settings/app_general_settings.dart';
import 'package:findatherapistapp/screens/admin/debug_screen/debug_screen.dart';
import 'package:findatherapistapp/screens/common/loading_screen/loading_screen.dart';
import 'package:findatherapistapp/screens/common/not_found_screen/not_found_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../screens/common/all_therapists_screen/all_therapists_screen.dart';

import '../screens/common/login_screen/login_screen.dart';
import '../screens/common/settings_screen/settings_screen.dart';
import '../screens/common/welcome_main_screen/welcome_main_screen.dart';
import '../screens/therapist_area/therapist_personal_profile_screen/therapist_personal_profile_screen.dart';
import '../screens/user_area/user_profile_screen/user_profile_screen.dart';
import '../screens/user_area/user_request_screen/user_request_screen.dart';

class Routes {
  /// COMMON ROUTES

  static RouteConfig loginScreen = RouteConfig(
    path: '/login',
    name: 'Login Screen',
    builder: (context) => const LoginScreen(),
  );

  static RouteConfig welcomeMainScreen = RouteConfig(
    path: '/',
    name: 'Welcome Main Screen',
    builder: (context) => const WelcomeMainScreen(),
  );

  static RouteConfig settingsScreen = RouteConfig(
    path: '/settings-screen',
    name: 'Settings Screen',
    builder: (context) => const SettingsScreen(),
  );

  static RouteConfig allTherapistsScreen = RouteConfig(
    path: '/all-therapists',
    name: 'All Therapists Screen',
    builder: (context) => const AllTherapistsScreen(),
  );

  static RouteConfig notFoundScreen = RouteConfig(
    path: '/404',
    name: '404 Not Found',
    builder: (context) => const NotFoundScreen(),
  );

  static RouteConfig loadingScreen = RouteConfig(
      path: '/loading',
      name: 'Loading',
      builder: (context) => const LoadingScreen());

  /// USER AREA ROUTES

  static RouteConfig userProfileScreen = RouteConfig(
    path: '/user-profile',
    name: 'User Profile Screen',
    builder: (context) => const UserProfileScreen(),
  );

  static RouteConfig userRequestScreen = RouteConfig(
    path: '/user-request',
    name: 'User Request',
    builder: (context) => const UserRequestScreen(),
  );

  /// THERAPIST AREA ROUTES

  static RouteConfig therapistProfileScreen = RouteConfig(
    path: '/therapist-profile',
    name: 'Therapist Profile Screen',
    builder: (context) => const TherapistPersonalProfileScreen(),
  );

  /// ADMIN AREA ROUTES

  static RouteConfig debugScreen = RouteConfig(
    path: '/debug-screen',
    name: 'Debug Screen',
    builder: (context) => const DebugScreen(),
  );

  static List<GoRoute> _generateRoutes() {
    List<RouteConfig> publicRoutes = [
      loginScreen,
      welcomeMainScreen,
      settingsScreen,
      userProfileScreen,
      userRequestScreen,
      therapistProfileScreen,
      notFoundScreen,
      loadingScreen,
      debugScreen,
      allTherapistsScreen
    ];
    return publicRoutes
        .map((routeConfig) => GoRoute(
              path: routeConfig.path,
              builder: (context, state) => routeConfig.builder(context),
            ))
        .toList();
  }

  static final GoRouter router = GoRouter(
    initialLocation:
        DebugConfig.forceDebugScreen ? DebugConfig.debugScreen.path : null,
    routes: _generateRoutes(),
  );
}

class RouteConfig {
  final String path;
  final Widget Function(BuildContext) builder;
  final String name;

  const RouteConfig({
    required this.path,
    required this.builder,
    required this.name,
  });
}
