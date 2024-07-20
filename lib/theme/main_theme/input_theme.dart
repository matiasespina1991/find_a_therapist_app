import 'package:flutter/material.dart';
import 'package:findatherapistapp/app_settings/theme_settings.dart';

class InputTheme {
  static InputDecorationTheme inputDecorationTheme(
      Brightness brightness, ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: brightness == Brightness.light
          ? ThemeSettings.inputBackgroundColor.lightModePrimary
          : ThemeSettings.inputBackgroundColor.darkModePrimary,
      hintStyle: TextStyle(
        color: brightness == Brightness.light
            ? ThemeSettings.primaryTextColor.lightModePrimary.withOpacity(0.4)
            : ThemeSettings.primaryTextColor.darkModePrimary.withOpacity(0.4),
      ),
      labelStyle: TextStyle(
        color: brightness == Brightness.light
            ? ThemeSettings.primaryTextColor.lightModePrimary
            : ThemeSettings.primaryTextColor.darkModePrimary,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: ThemeSettings.inputsBorderRadius,
        borderSide: BorderSide(
          color: brightness == Brightness.light
              ? ThemeSettings.primaryTextColor.lightModePrimary
              : ThemeSettings.primaryTextColor.darkModePrimary,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: ThemeSettings.inputsBorderRadius,
        borderSide: BorderSide(
          color: brightness == Brightness.light
              ? ThemeSettings.primaryTextColor.lightModePrimary
              : ThemeSettings.primaryTextColor.darkModePrimary,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: ThemeSettings.inputsBorderRadius,
        borderSide: BorderSide(color: ThemeSettings.errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: ThemeSettings.inputsBorderRadius,
        borderSide: BorderSide(
          color: brightness == Brightness.light
              ? ThemeSettings.primaryTextColor.lightModePrimary
              : ThemeSettings.primaryTextColor.darkModePrimary,
        ),
      ),
    );
  }
}
