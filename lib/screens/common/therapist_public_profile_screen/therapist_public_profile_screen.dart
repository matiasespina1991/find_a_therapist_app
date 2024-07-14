import 'package:country_picker/country_picker.dart';
import 'package:expandable/expandable.dart';
import 'package:findatherapistapp/app_settings/theme_settings.dart';
import 'package:findatherapistapp/utils/admin/to_capital_case.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

import '../../../generated/l10n.dart';
import '../../../models/therapist_model.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';

class TherapistPublicProfileScreen extends StatelessWidget {
  final TherapistModel therapist;

  const TherapistPublicProfileScreen({super.key, required this.therapist});

  @override
  Widget build(BuildContext context) {
    print(therapist.therapistInfo.specializations);

    return AppScaffold(
      useTopAppBar: true,
      showScreenTitleInAppBar: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: CachedNetworkImageProvider(
                          therapist.therapistInfo.profilePictureUrl.small,
                        ),
                      ),
                    ),
                    if (therapist.isOnline)
                      Positioned(
                        bottom: 1.5,
                        right: 2,
                        child: Card(
                          elevation: 0.5,
                          child: Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: therapist.isOnline
                                  ? Colors.green
                                  : Colors.red,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${therapist.therapistInfo.firstName} ${therapist.therapistInfo.lastName}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (therapist.therapistInfo.userInfoIsVerified)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: therapist.subscription.plan == 'gold'
                                  ? Image.asset(
                                      'lib/assets/icons/gold-plan-badge.png',
                                      width: 15,
                                    )
                                  : Image.asset(
                                      'lib/assets/icons/verified-badge.png',
                                      width: 15,
                                    ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        therapist.therapistInfo.specializations
                            .map((specialization) =>
                                toCapitalCase(specialization))
                            .join(', '),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                        ),
                      ),
                      SizedBox(height: 4),

                      /// location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                          SizedBox(width: 4),
                          Row(
                            children: [
                              Text(
                                '${therapist.therapistInfo.location.city}, ${CountryLocalizations.of(context)?.countryName(countryCode: therapist.therapistInfo.location.country)}',
                                style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        therapist.therapistInfo.bio,
                        style: TextStyle(
                          fontSize: 15.5,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                          fontFamily: 'OpenSans',
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(S.of(context).languages,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            Text(
              therapist.therapistInfo.spokenLanguages
                  .map((languageCode) => toCapitalCase(
                      LocaleNames.of(context)!.nameOf(languageCode) ?? ''))
                  .join(', '),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Text(S.of(context).intro,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            Text(
              therapist.therapistInfo.publicPresentation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            if (therapist.aspects.positive.isNotEmpty)
              ExpandableNotifier(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expandable(
                      collapsed: ExpandableButton(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: therapist.aspects.positive.take(4).map(
                            (aspect) {
                              return Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:
                                      ThemeSettings.seedColor.withOpacity(0.17),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  '#${aspect}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      expanded: Column(
                        children: [
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: therapist.aspects.positive.map(
                              (aspect) {
                                return Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: ThemeSettings.seedColor
                                        .withOpacity(0.17),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    '#${aspect}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      heightFactor: 1,
                      alignment: Alignment.centerLeft,
                      child: ExpandableButton(
                        child: Container(
                          child: Text(
                            '⋯',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
            Center(
                child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.chat_outlined,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(S.of(context).contactMeButton),
                      ],
                    ))),
            const SizedBox(height: 20.0),
            Text(
              S.of(context).professionalCertificates,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            ...therapist.therapistInfo.professionalCertificates
                .map((certificate) => ListTile(
                      title: Text(certificate.title),
                      subtitle: Text(
                          '${certificate.institution}, ${certificate.yearObtained}'),
                      leading: Image.network(certificate.photoUrl),
                    ))
                .toList(),
          ],
        ),
      ),
      appBarTitle: '${therapist.therapistInfo.firstName}\'s profile',
      isProtected: true,
    );
  }
}
