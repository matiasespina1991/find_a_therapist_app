import 'package:country_picker/country_picker.dart';
import 'package:expandable/expandable.dart';
import 'package:findatherapistapp/app_settings/theme_settings.dart';
import 'package:findatherapistapp/utils/admin/to_capital_case.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../../../generated/l10n.dart';
import '../../../models/therapist_model.dart';
import '../../../providers/providers_all.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';

class TherapistPublicProfileScreen extends ConsumerStatefulWidget {
  final TherapistModel therapist;

  const TherapistPublicProfileScreen({super.key, required this.therapist});

  @override
  ConsumerState<TherapistPublicProfileScreen> createState() =>
      _TherapistPublicProfileScreenState();
}

class _TherapistPublicProfileScreenState
    extends ConsumerState<TherapistPublicProfileScreen> {
  bool translateToUserDefinedLanguage = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _themeProvider = ref.watch(themeProvider);

        const TranslateLanguage sourceLanguage = TranslateLanguage.english;
        final TranslateLanguage targetLanguage =
            Localizations.localeOf(context).languageCode.toLowerCase() == 'en'
                ? TranslateLanguage.english
                : TranslateLanguage.values.firstWhere(
                    (lang) =>
                        lang.bcpCode ==
                        Localizations.localeOf(context)
                            .languageCode
                            .toLowerCase(),
                    orElse: () => TranslateLanguage.english,
                  );

        final onDeviceTranslator = OnDeviceTranslator(
            sourceLanguage: sourceLanguage, targetLanguage: targetLanguage);

        return AppScaffold(
          actions: [
            IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  (_themeProvider.themeMode == ThemeMode.light &&
                          !translateToUserDefinedLanguage)
                      ? Colors.transparent
                      : (_themeProvider.themeMode == ThemeMode.dark &&
                              !translateToUserDefinedLanguage)
                          ? Colors.black.withOpacity(0.1)
                          : Colors.white.withOpacity(0.1),
                ),
              ),
              icon: const Icon(
                Icons.g_translate,
              ),
              color: (_themeProvider.themeMode == ThemeMode.light &&
                      translateToUserDefinedLanguage)
                  ? Colors.white
                  : Colors.white,
              onPressed: () {
                setState(() {
                  translateToUserDefinedLanguage =
                      !translateToUserDefinedLanguage;
                });
              },
            ),
          ],
          useTopAppBar: true,
          showScreenTitleInAppBar: false,
          body: SingleChildScrollView(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 60,
                  ),
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
                                    widget.therapist.therapistInfo
                                        .profilePictureUrl.small,
                                  ),
                                ),
                              ),
                              if (widget.therapist.isOnline)
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
                                        color: widget.therapist.isOnline
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
                                        '${widget.therapist.therapistInfo.firstName} ${widget.therapist.therapistInfo.lastName}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (widget.therapist.therapistInfo
                                        .userInfoIsVerified)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: widget.therapist.subscription
                                                    .plan ==
                                                'gold'
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
                                const SizedBox(height: 4),
                                if (translateToUserDefinedLanguage)
                                  FutureBuilder<String>(
                                    future: onDeviceTranslator.translateText(
                                      widget.therapist.therapistInfo
                                          .specializations
                                          .map((specialization) =>
                                              toCapitalCase(specialization))
                                          .join(', '),
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text(
                                          widget.therapist.therapistInfo
                                              .specializations
                                              .map((specialization) =>
                                                  toCapitalCase(specialization))
                                              .join(', '),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[500],
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        debugPrint(
                                            'Error when trying to translate specializations: ${snapshot.error}');
                                        return Text(
                                          '.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[500],
                                          ),
                                        );
                                      } else {
                                        return Text(
                                          snapshot.data ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[500],
                                          ),
                                        );
                                      }
                                    },
                                  )
                                else
                                  Text(
                                    widget
                                        .therapist.therapistInfo.specializations
                                        .map((specialization) =>
                                            toCapitalCase(specialization))
                                        .join(', '),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: _themeProvider.themeMode ==
                                              ThemeMode.dark
                                          ? Colors.white
                                          : Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Row(
                                      children: [
                                        Text(
                                          '${widget.therapist.therapistInfo.location.city}, ${CountryLocalizations.of(context)?.countryName(countryCode: widget.therapist.therapistInfo.location.country)}',
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
                                const SizedBox(height: 4),
                                if (translateToUserDefinedLanguage)
                                  FutureBuilder<String>(
                                    future: onDeviceTranslator.translateText(
                                        widget.therapist.therapistInfo.bio),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text(
                                          widget.therapist.therapistInfo.bio,
                                          style: TextStyle(
                                            fontSize: 15.5,
                                            color: Colors.grey[700],
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'OpenSans',
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            'Error when trying to translate intro text: ${snapshot.error}');
                                      } else {
                                        return Text(
                                          snapshot.data ?? '',
                                          style: TextStyle(
                                            fontSize: 15.5,
                                            color: Colors.grey[700],
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'OpenSans',
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      }
                                    },
                                  )
                                else
                                  Text(
                                    widget.therapist.therapistInfo.bio,
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                      Text(
                        widget.therapist.therapistInfo.spokenLanguages
                            .map((languageCode) => toCapitalCase(
                                LocaleNames.of(context)!.nameOf(languageCode) ??
                                    ''))
                            .join(', '),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        S.of(context).therapistAboutMe,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (translateToUserDefinedLanguage)
                        FutureBuilder<String>(
                          future: onDeviceTranslator.translateText(widget
                              .therapist.therapistInfo.publicPresentation),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                widget
                                    .therapist.therapistInfo.publicPresentation,
                                style: Theme.of(context).textTheme.bodyMedium,
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                  'Error when trying to translate intro text: ${snapshot.error}');
                            } else {
                              return Text(
                                snapshot.data ?? '',
                                style: Theme.of(context).textTheme.bodyMedium,
                              );
                            }
                          },
                        )
                      else
                        Text(
                          widget.therapist.therapistInfo.publicPresentation,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      const SizedBox(height: 16.0),
                      if (widget.therapist.aspects.positive.isNotEmpty)
                        ExpandableNotifier(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expandable(
                                collapsed: ExpandableButton(
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: widget.therapist.aspects.positive
                                        .take(4)
                                        .map(
                                      (aspect) {
                                        return Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: ThemeSettings.seedColor
                                                .withOpacity(0.17),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            '#${aspect}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
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
                                      children:
                                          widget.therapist.aspects.positive.map(
                                        (aspect) {
                                          return Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: ThemeSettings.seedColor
                                                  .withOpacity(0.17),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              '#${aspect}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
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
                                  const SizedBox(width: 8),
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
                      ...widget.therapist.therapistInfo.professionalCertificates
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
              ],
            ),
          ),
          appBarTitle: '${widget.therapist.therapistInfo.firstName}\'s profile',
          isProtected: true,
        );
      },
    );
  }
}
