import 'package:findatherapistapp/utils/ui/is_dark_mode.dart';
import 'package:flutter/material.dart';

import '../../app_settings/theme_settings.dart';

class ThemeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ThemeAppBar({super.key, this.appBarHeight, this.title});

  final double? appBarHeight;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: isDarkMode(context)
          ? ThemeSettings.appbarOnBackgroundColor.darkModePrimary
          : ThemeSettings.appbarOnBackgroundColor.lightModePrimary,
      title: Text(
        title ?? '',
      ),
      actions: const <Widget>[],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? kToolbarHeight);
}
