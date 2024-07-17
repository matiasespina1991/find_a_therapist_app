import 'package:findatherapistapp/app_settings/theme_settings.dart';
import 'package:findatherapistapp/widgets/LoadingCircle/loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';

import '../../app_settings/app_general_settings.dart';
import '../../generated/l10n.dart';
import '../../providers/providers_all.dart';
import '../../routes/routes.dart';

class ThemeFloatingSpeedDialMenu extends ConsumerStatefulWidget {
  final bool hideFloatingSpeedDialMenu;
  final ValueNotifier<bool> isDialOpenNotifier;
  final bool loadingMode;

  const ThemeFloatingSpeedDialMenu({
    super.key,
    required this.hideFloatingSpeedDialMenu,
    required this.isDialOpenNotifier,
    this.loadingMode = false,
  });

  @override
  _ThemeFloatingSpeedDialMenuState createState() =>
      _ThemeFloatingSpeedDialMenuState();
}

class _ThemeFloatingSpeedDialMenuState
    extends ConsumerState<ThemeFloatingSpeedDialMenu> {
  @override
  Widget build(BuildContext context) {
    double childMenuFontSize = 17;
    final theme = ref.watch(themeProvider);
    bool isDarkMode = theme.themeMode == ThemeMode.dark;

    return SpeedDial(
      buttonSize: const Size(53, 53),
      backgroundColor: isDarkMode
          ? ThemeSettings.floatingSpeedDialBackgroundColor.darkModePrimary
          : ThemeSettings.floatingSpeedDialBackgroundColor.lightModePrimary,
      closeManually:
          false, // If set to true, dont try to add dynamic items or state-dependent items, they wont update
      animationDuration: const Duration(milliseconds: 200),
      elevation: 1.5,
      spacing: 10.0,
      visible: widget.hideFloatingSpeedDialMenu |
              !AppGeneralSettings.useFloatingSpeedDialMenu
          ? false
          : true,
      icon: Icons.add,
      activeIcon: Icons.close,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      curve: Curves.easeInOut,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.settings),
          label: S.of(context).settingsButton,
          labelStyle: TextStyle(fontSize: childMenuFontSize),
          onTap: () {
            context.push(Routes.settingsScreen.path);
            // Add your action here
          },
        ),
        SpeedDialChild(
          child: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
          ),
          label: isDarkMode ? S.of(context).lightMode : S.of(context).darkMode,
          labelStyle: TextStyle(fontSize: childMenuFontSize),
          onTap: () {
            ref.read(themeProvider).toggleTheme(!isDarkMode);
            setState(() {
              isDarkMode = !isDarkMode;
            });
          },
        ),
        SpeedDialChild(
          child: const Icon(
            Icons.list_alt,
          ),
          label: S.of(context).allTherapists,
          labelStyle: TextStyle(fontSize: childMenuFontSize),
          onTap: () {
            context.push(Routes.allTherapistsScreen.path);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.logout),
          label: S.of(context).logoutButton,
          labelStyle: TextStyle(fontSize: childMenuFontSize),
          onTap: () {
            ref.read(authProvider).signOut(context);
          },
        ),
      ],
      onOpen: () {
        widget.isDialOpenNotifier.value = true;
      },
      onClose: () {
        widget.isDialOpenNotifier.value = false;
      },
      child: widget.loadingMode!
          ? Padding(
              padding: EdgeInsets.all(11.0),
              child: LoadingCircle(
                color:
                    isDarkMode ? Colors.black : Colors.white.withOpacity(0.8),
              ),
            )
          : null,
    );
  }
}
