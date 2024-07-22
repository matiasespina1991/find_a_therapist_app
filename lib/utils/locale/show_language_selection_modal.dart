import 'package:dash_flags/dash_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

import '../../widgets/ModalTopChip/modal_top_chip.dart';
import '../admin/to_capital_case.dart';
import 'all_locales_list.dart';

void showLanguageSelectionModal(BuildContext context,
    {List<String>? availableLanguages,
    required List<String> selectedLanguages,
    required Function(List<String>) onLanguagesSelected}) {
  availableLanguages ??= allLocales;

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
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 30, left: 10, right: 10),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: availableLanguages!.map((String languageCode) {
                        return CheckboxListTile(
                          title: Row(
                            children: [
                              LanguageFlag(
                                  height: 20,
                                  language: Language.fromCode(languageCode)),
                              const SizedBox(width: 10),
                              Text(LocaleNames.of(context)!
                                          .nameOf(languageCode) !=
                                      null
                                  ? toCapitalCase(LocaleNames.of(context)!
                                      .nameOf(languageCode)!)
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
                      }).toList(),
                    ),
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
