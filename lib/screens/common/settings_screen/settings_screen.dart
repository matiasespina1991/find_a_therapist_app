import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../generated/l10n.dart';
import '../../../providers/providers_all.dart';
import '../../../utils/ui/is_dark_mode.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).lightMode,
                    style: TextStyle(
                      fontWeight: isDarkMode(context)
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  const Text(
                    ' / ',
                  ),
                  Text(
                    S.of(context).darkMode,
                    style: TextStyle(
                      fontWeight: isDarkMode(context)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Center(
                child: Switch(
                  thumbIcon: WidgetStateProperty.all(Icon(
                    isDarkMode(context) ? Icons.dark_mode : Icons.light_mode,
                    color: Colors.white,
                  )),
                  value: isDarkMode(context),
                  onChanged: (value) {
                    ref.read(themeProvider).toggleTheme(value);
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                S.of(context).changeLanguageButton,
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      ref.read(localeProvider).setLocale(const Locale('en'));
                    },
                    child: const Text(
                      '🇺🇸',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('/'),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      ref.read(localeProvider).setLocale(const Locale('es'));
                    },
                    child: const Text(
                      '🇪🇸',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('/'),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      ref.read(localeProvider).setLocale(const Locale('de'));
                    },
                    child: const Text(
                      '🇩🇪',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      )),
    );
  }
}
