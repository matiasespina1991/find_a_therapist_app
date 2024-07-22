import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_settings/theme_settings.dart';
import '../../providers/providers_all.dart'; // Asegúrate de importar los providers necesarios

class ThemeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ThemeAppBar({
    super.key,
    this.appBarHeight,
    this.title,
    this.actions,
    this.centerTitle = true,
    this.backButton,
  });

  final double? appBarHeight;
  final Function()? backButton;
  final String? title;
  final List<Widget>? actions;
  final bool? centerTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode =
        ref.watch(themeProvider).themeMode == ThemeMode.dark;
    final iconColor = isDarkMode
        ? ThemeSettings.appbarOnBackgroundColor.darkModePrimary
        : ThemeSettings.appbarOnBackgroundColor.lightModePrimary;

    return AppBar(
      leading: backButton != null
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios, color: iconColor),
              onPressed: backButton,
            )
          : null,
      elevation: 0,
      backgroundColor: isDarkMode
          ? ThemeSettings.appbarBackgroundColor.darkModePrimary
          : ThemeSettings.appbarBackgroundColor.lightModePrimary,
      shadowColor: Colors.black.withOpacity(0.1),
      scrolledUnderElevation: 4.0,
      toolbarHeight: appBarHeight ?? kToolbarHeight,
      iconTheme: IconThemeData(color: iconColor),
      centerTitle: centerTitle,
      title: Text(
        title ?? '',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 19,
              color: isDarkMode
                  ? ThemeSettings.appbarOnBackgroundColor.darkModePrimary
                      .withOpacity(0.9)
                  : ThemeSettings.appbarOnBackgroundColor.lightModePrimary
                      .withOpacity(0.6),
            ),
      ),
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? kToolbarHeight);
}
