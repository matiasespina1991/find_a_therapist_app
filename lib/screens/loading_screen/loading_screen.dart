import 'package:flutter/material.dart';

import '../../app_settings/theme_settings.dart';
import '../../widgets/LoadingCircle/loading_circle.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: ThemeSettings.useSafeArea,
      child: Scaffold(
        backgroundColor: isDarkMode
            ? ThemeSettings.scaffoldBackgroundColor.darkModePrimary
            : ThemeSettings.scaffoldBackgroundColor.lightModePrimary,
        body: const Center(
          child: LoadingCircle(),
        ),
      ),
    );
  }
}
