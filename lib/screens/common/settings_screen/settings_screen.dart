import 'package:animate_do/animate_do.dart';
import 'package:dash_flags/dash_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app_settings/language_settings.dart';
import '../../../generated/l10n.dart';
import '../../../providers/providers_all.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../../widgets/LocaleSelector/locale_selector.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        ref.watch(themeProvider).themeMode == ThemeMode.dark;
    return AppScaffold(
      centerTitle: true,
      useTopAppBar: true,
      appBarTitle: S.of(context).settingsScreenTitle,
      isProtected: false,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: [
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).lightMode,
                    style: TextStyle(
                      fontWeight:
                          isDarkMode ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  const Text(
                    ' / ',
                  ),
                  Text(
                    S.of(context).darkMode,
                    style: TextStyle(
                      fontWeight:
                          isDarkMode ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Center(
                child: Switch(
                  thumbIcon: WidgetStateProperty.all(Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: Colors.white,
                  )),
                  value: isDarkMode,
                  onChanged: (value) {
                    ref.read(themeProvider).toggleTheme(value);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                S.of(context).changeLanguageButton,
              ),
              const SizedBox(height: 14),
              const LocaleSelector(),
            ],
          ),
        ],
      )),
    );
  }
}
