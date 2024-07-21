import 'package:flutter/cupertino.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

import '../admin/to_capital_case.dart';

String getLocalizedLanguagesNames(BuildContext context,
    {required List<String> languageCodes}) {
  return languageCodes
      .map((code) => LocaleNames.of(context)!.nameOf(code) != null
          ? toCapitalCase(LocaleNames.of(context)!.nameOf(code)!)
          : code)
      .join(', ');
}
