import 'package:animate_do/animate_do.dart';
import 'package:dash_flags/dash_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_settings/language_settings.dart';
import '../../providers/providers_all.dart';

class LocaleSelector extends ConsumerWidget {
  const LocaleSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode =
        ref.watch(themeProvider).themeMode == ThemeMode.dark;
    final currentLocale = ref.watch(localeProvider).locale;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: LanguageSettings.supportedTranslationLocales.map((localeCode) {
        final bool isSelected = currentLocale.languageCode == localeCode;

        return Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                ref.read(localeProvider).setLocale(Locale(localeCode));
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: FadeIn(
                      duration: const Duration(milliseconds: 50),
                      animate: isSelected,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDarkMode
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1))
                              : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: LanguageFlag(
                      language: Language.values.firstWhere(
                        (lang) => lang.name == localeCode,
                        orElse: () =>
                            Language.en, // default to English if not found
                      ),
                      height: 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            if (localeCode != LanguageSettings.supportedTranslationLocales.last)
              const Text('/'),
            const SizedBox(width: 6),
          ],
        );
      }).toList(),
    );
  }
}
