import 'package:dash_flags/dash_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

StatelessWidget getDashFlagByCountryCode(String countryCode) {
  Container setCountryFlag(String countryCode) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.5),
      ),
      child: SvgPicture.asset(
        'lib/assets/extra_dash_flags/${countryCode.toLowerCase()}.svg',
        height: 19,
        width: 19,
      ),
    );
  }

  if (countryCode == 'IN' ||
      countryCode == 'AS' ||
      countryCode == 'DO' ||
      countryCode == 'IS' ||
      countryCode == 'AC') {
    return setCountryFlag(countryCode);
  }

  return CountryFlag(
    height: 19,
    country: Country.fromCode(countryCode),
  );
}
