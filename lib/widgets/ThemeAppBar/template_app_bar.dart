import 'package:flutter/material.dart';

import '../../app_settings/theme_settings.dart';
import '../../utils/ui/is_dark_mode.dart';

class ThemeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ThemeAppBar(
      {super.key,
      this.appBarHeight,
      this.title,
      this.actions,
      this.centerTitle = true});

  final double? appBarHeight;
  final String? title;
  final List<Widget>? actions;
  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    final _isDarkMode = isDarkMode(context);
    final iconColor = _isDarkMode
        ? ThemeSettings.appbarOnBackgroundColor.darkModePrimary
        : ThemeSettings.appbarOnBackgroundColor.lightModePrimary;
    return AppBar(
      iconTheme: IconThemeData(color: iconColor),
      centerTitle: centerTitle,
      foregroundColor: _isDarkMode
          ? ThemeSettings.appbarOnBackgroundColor.darkModePrimary
          : ThemeSettings.appbarOnBackgroundColor.lightModePrimary,
      title: Text(
        title ?? '',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 19,
              color: _isDarkMode
                  ? ThemeSettings.appbarOnBackgroundColor.darkModePrimary
                  : ThemeSettings.appbarOnBackgroundColor.lightModePrimary,
            ),
      ),
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? kToolbarHeight);
}
