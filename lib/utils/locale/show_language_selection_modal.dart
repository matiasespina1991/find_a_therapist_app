import 'package:dash_flags/dash_flags.dart';
import 'package:findatherapistapp/app_settings/language_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:diacritic/diacritic.dart';

import '../../generated/l10n.dart';
import '../../widgets/ModalTopChip/modal_top_chip.dart';
import '../admin/to_capital_case.dart';
import 'all_locales_list.dart';

void showLanguageSelectionModal(BuildContext context,
    {List<String>? availableLanguages,
    required List<String> userSelectedLanguages,
    required Function(List<String>) onLanguagesSelected,
    bool useSearch = false}) {
  availableLanguages ??= allLocales;

  TextEditingController searchController = TextEditingController();

  List<String> languagesWithoutIgnoredLocales(List<String> languages) {
    return languages
        .where((lang) => !LanguageSettings.ignoredLocales.contains(lang))
        .toList();
  }

  List<String> filteredLanguages =
      languagesWithoutIgnoredLocales(availableLanguages);

  List<String> selectedLanguages = userSelectedLanguages;

  print('selectedLanguages: $selectedLanguages');

  void _sortLanguages() {
    filteredLanguages.sort((a, b) {
      String nameA = removeDiacritics(LocaleNames.of(context)?.nameOf(a) ?? a);
      String nameB = removeDiacritics(LocaleNames.of(context)?.nameOf(b) ?? b);
      return nameA.toLowerCase().compareTo(nameB.toLowerCase());
    });
  }

  _sortLanguages();

  Widget LanguageCheckboxTile(
      {required String languageCode,
      required List<String> selectedLanguages,
      required Function(List<String>) onLanguagesSelected,
      required StateSetter modalSetState}) {
    return CheckboxListTile(
      title: Row(
        children: [
          LanguageFlag(height: 20, language: Language.fromCode(languageCode)),
          const SizedBox(width: 10),
          Text(LocaleNames.of(context)!.nameOf(languageCode) != null
              ? toCapitalCase(LocaleNames.of(context)!.nameOf(languageCode)!)
              : languageCode),
        ],
      ),
      value: selectedLanguages.contains(languageCode),
      onChanged: (bool? value) {
        modalSetState(() {
          if (value == true) {
            selectedLanguages.add(languageCode);
          } else {
            if (selectedLanguages.length > 1) {
              selectedLanguages.remove(languageCode);
            }
          }
        });
        onLanguagesSelected(selectedLanguages);
      },
    );
  }

  showModalBottomSheet(
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.8,
    ),
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          const ModalTopChip(),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter modalSetState) {
              void _filterLanguages(String query) {
                if (query.isEmpty) {
                  filteredLanguages =
                      languagesWithoutIgnoredLocales(availableLanguages!);
                  selectedLanguages = userSelectedLanguages;
                } else {
                  filteredLanguages =
                      languagesWithoutIgnoredLocales(availableLanguages!)
                          .where((lang) {
                    String localeName =
                        LocaleNames.of(context)?.nameOf(lang) ?? lang;
                    return removeDiacritics(localeName)
                        .toLowerCase()
                        .contains(query.toLowerCase());
                  }).toList();

                  selectedLanguages = selectedLanguages.where((lang) {
                    String localeName =
                        LocaleNames.of(context)?.nameOf(lang) ?? lang;
                    return removeDiacritics(localeName)
                        .toLowerCase()
                        .contains(query.toLowerCase());
                  }).toList();
                }
                _sortLanguages();
                modalSetState(() {});
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 30, left: 5, right: 5),
                  child: Column(
                    children: [
                      if (useSearch)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              labelText: S.of(context).searchLanguages,
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (value) =>
                                _filterLanguages(removeDiacritics(value)),
                          ),
                        ),
                      SizedBox(height: useSearch ? 19 : 0),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            ...selectedLanguages.map((String languageCode) {
                              return LanguageCheckboxTile(
                                languageCode: languageCode,
                                selectedLanguages: selectedLanguages,
                                onLanguagesSelected: onLanguagesSelected,
                                modalSetState: modalSetState,
                              );
                            }),
                            if (searchController.text.isEmpty)
                              const Divider(
                                height: 40,
                              ),
                            ...filteredLanguages.map((String languageCode) {
                              if (selectedLanguages.contains(languageCode)) {
                                return Container();
                              }

                              return LanguageCheckboxTile(
                                languageCode: languageCode,
                                selectedLanguages: selectedLanguages,
                                onLanguagesSelected: onLanguagesSelected,
                                modalSetState: modalSetState,
                              );
                            }),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
