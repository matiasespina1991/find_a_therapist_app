import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../screens/common/home_screen/home_screen.dart';
import '../screens/common/login_screen/login_screen.dart';
import '../screens/therapist_area/therapist_profile_screen.dart';
import '../screens/user_area/user_profile_screen/user_profile_screen.dart';
import '../screens/user_area/user_request_screen/user_request_screen.dart';

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

class Routes {
  /// COMMON ROUTES

  static RouteConfig loginScreen = RouteConfig(
    path: '/login',
    name: 'Login Screen',
    builder: (context) => const LoginScreen(),
  );

  static RouteConfig homeScreen = RouteConfig(
    path: '/',
    name: 'Home Screen',
    builder: (context) => const HomeScreen(),
  );

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
    builder: (context) => const TherapistProfileScreen(),
  );

  static List<GoRoute> _generateRoutes() {
    List<RouteConfig> allRoutes = [
      loginScreen,
      homeScreen,
      userProfileScreen,
      userRequestScreen,
    ];

    return allRoutes
        .map((routeConfig) => GoRoute(
              path: routeConfig.path,
              builder: (context, state) => routeConfig.builder(context),
            ))
        .toList();
  }

  static final GoRouter router = GoRouter(
    routes: _generateRoutes(),
  );
}
