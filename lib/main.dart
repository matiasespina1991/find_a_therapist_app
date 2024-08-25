import 'package:country_picker/country_picker.dart';
import 'package:findatherapistapp/providers/therapist_provider.dart';
import 'package:findatherapistapp/routes/routes.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:findatherapistapp/providers/providers_all.dart';
import 'app_settings/auth_config.dart';
import 'firebase_options.dart';
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
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await FirebaseAppCheck.instance.activate(
        // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
        // argument for `webProvider`
        webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
        // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Safety Net provider
        // 3. Play Integrity provider
        androidProvider: AndroidProvider.debug,
        // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Device Check provider
        // 3. App Attest provider
        // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
        appleProvider: AppleProvider.appAttest,
      );
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
    final isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    ref.listen(authProvider, (previous, next) {
      if (next.user != null) {
        Future(() {
          ref.read(therapistProvider.notifier).fetchTherapist(next.user!.uid);
        });
      }
    });

    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
          effect: ShimmerEffect(
            baseColor: isDarkMode
                ? ThemeSettings.seedColor.withOpacity(0.1)
                : Colors.grey[300]!, // Color base del shimmer
            highlightColor: isDarkMode
                ? Colors.grey.withOpacity(0.25)
                : Colors.grey[100]!, // Color de resaltado del shimmer
            duration: const Duration(milliseconds: 2500),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
        supportedLocales: LanguageSettings.supportedTranslationLocales
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
