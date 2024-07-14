import 'package:country_picker/country_picker.dart';
import 'package:findatherapistapp/routes/routes.dart';
import 'package:findatherapistapp/screens/admin/debug_screen/_print_all_terms_therapists_screen.dart';
import 'package:findatherapistapp/screens/common/home_screen/home_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:findatherapistapp/providers/providers_all.dart';
import 'app_settings/app_general_settings.dart';
import 'app_settings/auth_config.dart';
import 'globals.dart';
import 'app_settings/app_info.dart';
import 'app_settings/language_settings.dart';
import 'app_settings/theme_settings.dart';
import 'theme/main_theme/main_theme.dart';
import 'utils/debug/log_configurations.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  logConfigurations();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> initializeApp() async {
  if (AuthConfig.useFirebase) {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Error: Firebase initialization failed. $e');

      ///TODO: Show an error screen here or retry the initialization.
    }
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    final localeNotifier = ref.watch(localeProvider);

    return SkeletonizerConfig(
      data: const SkeletonizerConfigData(
          effect: ShimmerEffect(),
          enableSwitchAnimation: true,
          containersColor: ThemeSettings.forceSeedColor
              ? ThemeSettings.seedColor
              : Colors.grey),
      child: MaterialApp.router(
        scaffoldMessengerKey: snackbarKey,
        title: AppInfo.appName,
        theme: MainTheme.lightTheme,
        darkTheme: MainTheme.darkTheme,
        themeMode: themeNotifier.themeMode,
        locale: localeNotifier.locale,
        supportedLocales: LanguageSettings.supportedLocales
            .map((e) => Locale.fromSubtags(languageCode: e))
            .toList(),
        localizationsDelegates: const [
          LocaleNamesLocalizationsDelegate(),
          CountryLocalizations.delegate,
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          if (LanguageSettings.forceDefaultLanguage) {
            return const Locale(LanguageSettings.appDefaultLanguage);
          }
          if (locale != null) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
          }
          return supportedLocales.first;
        },
        routerDelegate: Routes.router.routerDelegate,
        routeInformationParser: Routes.router.routeInformationParser,
        routeInformationProvider: Routes.router.routeInformationProvider,
      ),
    );
  }
}
