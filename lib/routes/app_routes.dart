// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/login_screen/login_screen.dart';
import '../screens/not_found_screen/not_found_screen.dart';

class RouteConfig {
  final String path;
  final Widget Function(BuildContext) builder;

  const RouteConfig({required this.path, required this.builder});
}

class Routes {
  static const String homeScreen = 'home';
  static const String loginScreen = 'login';
  static const String notFoundScreen = 'not-found';

  /// static const String exampleRoute = 'example-route';

  static final Map<String, RouteConfig> routes = {
    homeScreen: RouteConfig(
      path: '/home',
      builder: (context) => const HomeScreen(),
    ),
    loginScreen: RouteConfig(
      path: '/login',
      builder: (context) => const LoginScreen(),
    ),
    notFoundScreen: RouteConfig(
      path: '/not-found',
      builder: (context) => const NotFoundScreen(),
    ),

    /// exampleRoute: RouteConfig(
    ///   path: '/example-route',
    ///   builder: (context) => const ExampleScreen(),
    /// ),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final route = routes.values.firstWhere(
      (route) => route.path == settings.name,
      orElse: () => RouteConfig(
        path: '/not-found',
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      ),
    );
    return MaterialPageRoute(
      builder: route.builder,
      settings: settings,
    );
  }

  static Map<String, WidgetBuilder> getRoutes() {
    return Map.fromEntries(
        routes.values.map((route) => MapEntry(route.path, route.builder)));
  }

  static String getPath(String routeName) => routes[routeName]?.path ?? '/';
}
