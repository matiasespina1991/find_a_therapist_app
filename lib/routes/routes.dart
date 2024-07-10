import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/login_screen/login_screen.dart';

class RouteConfig {
  final String path;
  final Widget Function(BuildContext) builder;
  // final bool isProtected;
  final String name;

  const RouteConfig(
      {required this.path,
      required this.builder,
      // this.isProtected = false,
      required this.name});
}

class Routes {
  static RouteConfig homeScreen = RouteConfig(
    path: '/',
    name: 'Home Screen',
    builder: (context) => const HomeScreen(),
  );

  static RouteConfig loginScreen = RouteConfig(
    path: '/login',
    name: 'Login Screen',
    builder: (context) => const LoginScreen(),
  );

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: homeScreen.path,
        builder: (context, state) => homeScreen.builder(context),
      ),
      GoRoute(
        path: loginScreen.path,
        builder: (context, state) => loginScreen.builder(context),
      ),
    ],
  );
}
