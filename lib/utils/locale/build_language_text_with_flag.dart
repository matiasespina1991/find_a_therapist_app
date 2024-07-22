import 'package:dash_flags/dash_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

import '../admin/to_capital_case.dart';

RichText buildLanguageText(BuildContext context,
    {required List<String> selectedLanguages}) {
  List<InlineSpan> spans = [];

  for (String languageCode in selectedLanguages) {
    spans.add(WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: LanguageFlag(
        height: 19,
        language: Language.fromCode(languageCode),
      ),
    ));
    spans.add(const TextSpan(text: '  '));
    spans.add(TextSpan(
      text: LocaleNames.of(context)!.nameOf(languageCode) != null
          ? toCapitalCase(LocaleNames.of(context)!.nameOf(languageCode)!)
          : languageCode,
    ));
    spans.add(const TextSpan(text: ',  '));
  }

  // Remove the last comma and space
  if (spans.isNotEmpty) {
    spans.removeLast();
  }

  return RichText(
    text: TextSpan(
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontSize: 15, height: 1.8),
      children: spans,
    ),
  );
}
