import 'dart:async';
import 'dart:developer';

import 'package:country_picker/country_picker.dart';

import 'package:dash_flags/dash_flags.dart' as dash_flags;
import 'package:findatherapistapp/utils/admin/update_all_therapists_aspects.dart';
import 'package:findatherapistapp/utils/admin/update_props_on_therapists_docs.dart';
import 'package:findatherapistapp/widgets/ModalTopChip/modal_top_chip.dart';
import 'package:findatherapistapp/widgets/NotificationModal/notification_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:findatherapistapp/models/general_models.dart';
import 'package:findatherapistapp/providers/locale_provider.dart';
import 'package:findatherapistapp/utils/admin/to_capital_case.dart';
import 'package:findatherapistapp/widgets/NotificationSnackbar/notification_snackbar.dart';

import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:findatherapistapp/widgets/LoadingCircle/loading_circle.dart';
import 'package:findatherapistapp/services/gemini_service.dart';
import 'package:findatherapistapp/services/speech_to_text_service.dart';
import 'package:go_router/go_router.dart';
import '../../../app_settings/theme_settings.dart';
import '../../../models/gemini_tags_response_model.dart';
import '../../../providers/providers_all.dart';
import '../../../routes/routes.dart';
import '../../../utils/debug/error_code_to_text.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/LocationSelectionModal/location_selection_modal.dart';
import '../../common/aspects_screen/aspects_screen.dart';

class UserRequestScreen extends ConsumerStatefulWidget {
  const UserRequestScreen({super.key});

  @override
  ConsumerState<UserRequestScreen> createState() => _UserRequestScreenState();
}

class _UserRequestScreenState extends ConsumerState<UserRequestScreen> {
  final TextEditingController _requestController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  String _requestLastText = '';
  final GeminiService _geminiService = GeminiService();
  final SpeechToTextService _speechService = SpeechToTextService();
  GeminiTagsResponse? _tagsResponse;
  bool isSendingRequest = false;
  bool _isListening = false;
  bool _isImprovingTranscription = false;
  bool _isAutoWriting = false;
  Timer? _autoWriteTimer;
  TextEditingController countryInputController = TextEditingController();
  TextEditingController stateProvinceInputController = TextEditingController();
  TextEditingController cityInputController = TextEditingController();

  String? defaultCountry;
  late UserRequestFilters therapistFilters;

  List<Country> countries = [];
  String listenedText = '';

  final ScrollController _scrollControllerPage1 = ScrollController();
  final ScrollController _scrollControllerPage2 = ScrollController();

  CountryService countryService = CountryService();

  List<String> selectedLanguages = ['en'];

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initializeSpeech();

    Locale currentLocale = ref.read(localeProvider).locale;

    selectedLanguages = [currentLocale.languageCode];

    therapistFilters = UserRequestFilters(
        remote: true,
        presential: true,
        location: LocationFilters(
            enabled: true, country: 'AU', state: null, city: null));
    List<Country> allCountries = countryService.getAll();

    setState(() {
      countries = allCountries;
    });

    stateProvinceInputController.text = '';

    if (therapistFilters.location.country == null) {
      countryInputController.text = '< Select a country >';
    } else {
      countryInputController.text =
          '  ${countryService.findByCode(therapistFilters.location.country)?.name}';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageController.text = _getLocalizedLanguageNames(selectedLanguages);
  }

  String _getLocalizedLanguageNames(List<String> languageCodes) {
    return languageCodes
        .map((code) => LocaleNames.of(context)!.nameOf(code) != null
            ? toCapitalCase(LocaleNames.of(context)!.nameOf(code)!)
            : code)
        .join(', ');
  }

  void _initializeSpeech() async {
    await _speechService.initialize();
  }

  @override
  void dispose() {
    _speechService.stopListening();
    _requestController.dispose();
    _autoWriteTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoWrite() async {
    if (_isListening) {
      _stopListening();
    }
    setState(() {
      _isAutoWriting = true;
    });

    final LocaleProvider localeService = ref.read(localeProvider);

    final newText = await _geminiService.generateAutoWriteText(
        language: localeService.locale.languageCode);
    int charIndex = 0;
    int blockSize = 1;

    _autoWriteTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (_isAutoWriting && charIndex < newText.length) {
        setState(() {
          int nextIndex = charIndex + blockSize;
          if (nextIndex > newText.length) {
            nextIndex = newText.length;
          }
          _requestController.text += newText.substring(charIndex, nextIndex);
          charIndex = nextIndex;
        });
      } else {
        _stopAutoWrite();
      }
    });
  }

  void _stopAutoWrite() async {
    setState(() {
      _isAutoWriting = false;
    });
    _autoWriteTimer?.cancel();
  }

  void _startListening() async {
    if (_isAutoWriting) {
      _stopAutoWrite();
    }

    var localeService = ref.watch(localeProvider);

    setState(() {
      _isListening = true;
      _requestLastText = _requestController.text;
    });

    _speechService.startListening(
      localeId: localeService.locale.languageCode,
      onResult: (text) {
        setState(() {
          listenedText = text;
          _requestController.text = _requestLastText + text;
        });
      },
    );
    setState(() {
      listenedText = '';
    });
  }

  void _stopListening() async {
    _speechService.stopListening();
    setState(() => _isListening = false);

    if (_requestController.text.isNotEmpty && listenedText.isNotEmpty) {
      await _improveTranscription(_requestController.text);
    }
  }

  Future<void> _improveTranscription(String text) async {
    setState(() {
      _isImprovingTranscription = true;
    });

    final improvedText = await _geminiService.improveTranscription(text);
    setState(() {
      _requestController.text = improvedText;
      _isImprovingTranscription = false;
      _requestLastText = improvedText;
    });
  }

  void _showLocationSelectionModal(BuildContext context, String type) {
    showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return LocationSelectionModal(
          type: type,
          therapistFilters: therapistFilters,
          stateProvinceInputController: stateProvinceInputController,
          onSelect: (selectedItem) {
            setState(() {
              if (type == 'state') {
                therapistFilters.location.state = selectedItem.isoCode;
                stateProvinceInputController.text = selectedItem.name;
                therapistFilters.location.city = null;
                cityInputController.clear();
              } else if (type == 'city') {
                therapistFilters.location.city = selectedItem.name;
                cityInputController.text = selectedItem.name;
              }
            });
          },
          cityInputController: cityInputController,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        ref.watch(themeProvider).themeMode == ThemeMode.dark;
    final therapistsLanguages = ref.watch(therapistsLanguagesProvider);

    return AppScaffold(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      ignoreGlobalPadding: true,
      backButton: () {
        if (_pageController.hasClients && _pageController.page == 0) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            context.go(Routes.welcomeMainScreen.path);
          }
        } else {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      setFloatingSpeedDialToLoadingMode:
          isSendingRequest || _isAutoWriting || _isImprovingTranscription,
      useTopAppBar: true,
      isProtected: true,
      appBarTitle: S.of(context).yourRequest,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const ClampingScrollPhysics(),
                children: [
                  _buildFirstPage(
                      context, isDarkMode, therapistsLanguages.languages),
                  _buildSecondPage(context, isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstPage(
      BuildContext context, bool isDarkMode, List<String> availableLanguages) {
    return SingleChildScrollView(
      controller: _scrollControllerPage1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${S.of(context).meetingType}:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                        dense: true,
                        onTap: () {
                          setState(() {
                            if (!therapistFilters.presential) return;

                            therapistFilters.remote = !therapistFilters.remote;
                          });
                        },
                        contentPadding: const EdgeInsets.only(
                            left: 16, right: 10, bottom: 1),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          borderRadius: ThemeSettings.buttonsBorderRadius,
                        ),
                        title: Text(S.of(context).remote,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 15,
                                )),
                        trailing: IgnorePointer(
                          child: Checkbox(
                              value: therapistFilters.remote,
                              onChanged: (value) {}),
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ListTile(
                        dense: true,
                        onTap: () {
                          setState(() {
                            if (!therapistFilters.remote) return;
                            therapistFilters.presential =
                                !therapistFilters.presential;
                          });
                        },
                        contentPadding: const EdgeInsets.only(
                            left: 16, right: 10, bottom: 1),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          borderRadius: ThemeSettings.buttonsBorderRadius,
                        ),
                        title: Text(S.of(context).presential,
                            overflow: TextOverflow.visible,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 15)),
                        trailing: IgnorePointer(
                          child: Checkbox(
                              value: therapistFilters.presential,
                              onChanged: (value) {}),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// Preferred Language Input
              Text(
                '${S.of(context).preferredLanguage}:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () =>
                    _showLanguageSelectionModal(context, availableLanguages),
                child: AbsorbPointer(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: isDarkMode
                              ? ThemeSettings.primaryTextColor.darkModePrimary
                              : ThemeSettings
                                  .primaryTextColor.lightModePrimary),
                      borderRadius: ThemeSettings.inputsBorderRadius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: _buildLanguageText(context)),
                        const Icon(Icons.add, size: 23),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${S.of(context).location}:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Checkbox(
                                  value: !therapistFilters.location.enabled,
                                  onChanged: (_) {
                                    setState(() {
                                      therapistFilters.location.enabled =
                                          !therapistFilters.location.enabled;
                                    });
                                  }),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    therapistFilters.location.enabled =
                                        !therapistFilters.location.enabled;
                                  });
                                },
                                child: Text('${S.of(context).worldwide}  🌐',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 15)),
                              ),
                            ]),
                      ),
                    ],
                  ),

                  /// Country Input
                  Visibility(
                    visible: therapistFilters.location.enabled,
                    child: GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: false,
                          onSelect: (Country country) {
                            setState(() {
                              if (therapistFilters.location.country !=
                                  country.countryCode) {
                                therapistFilters.location.state = null;
                                therapistFilters.location.city = null;
                                stateProvinceInputController.clear();
                                cityInputController.clear();
                              }

                              therapistFilters.location.country =
                                  country.countryCode;

                              countryInputController.text = '  ${country.name}';
                              defaultCountry = country.countryCode;
                            });
                          },
                        );
                      },
                      child: AbsorbPointer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            TextField(
                              decoration: InputDecoration(
                                label: Text(S.of(context).country),
                                contentPadding: const EdgeInsets.only(
                                    left: 15, right: 10, top: 11, bottom: 13),
                                isCollapsed: true,
                                hintText: '< ${S.of(context).selectACountry} >',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(),
                                prefixStyle: const TextStyle(
                                  fontSize: 0,
                                ),
                                prefix: Text(
                                  therapistFilters.location.enabled
                                      ? '${countryService.findByCode(therapistFilters.location.country)?.flagEmoji}'
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              controller: countryInputController,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// State/Province Input
                  Visibility(
                    visible: therapistFilters.location.enabled,
                    child: GestureDetector(
                      onTap: () {
                        _showLocationSelectionModal(context, 'state');
                      },
                      child: AbsorbPointer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            TextField(
                              textAlign: therapistFilters.location.state == null
                                  ? TextAlign.center
                                  : TextAlign.start,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                label: Text(S.of(context).stateProvince),
                                hintText: '< ${S.of(context).all} >',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontSize: 15,
                                    ),
                                border: const OutlineInputBorder(),
                              ),
                              controller: stateProvinceInputController,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  therapistFilters.location.state = null;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// City Input
                  Visibility(
                    visible: therapistFilters.location.enabled &&
                        therapistFilters.location.state != null,
                    child: GestureDetector(
                      onTap: () {
                        _showLocationSelectionModal(context, 'city');
                      },
                      child: AbsorbPointer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            TextField(
                              textAlign: therapistFilters.location.city == null
                                  ? TextAlign.center
                                  : TextAlign.start,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                label: Text(S.of(context).city),
                                hintText: '< ${S.of(context).all} >',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontSize: 15),
                                border: const OutlineInputBorder(),
                              ),
                              controller:
                                  cityInputController, // Usar el nuevo controlador
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// Next Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                iconAlignment: IconAlignment.end,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(right: 10, left: 20),
                  minimumSize: const Size(120, ThemeSettings.buttonsHeight),
                ),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Row(
                  children: [
                    Text(S.of(context).continueButton),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_ios, size: 16)
                  ],
                ),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       updatePropsOnTherapistsDocs();
              //     },
              //     child: Text('Test')),
            ],
          ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  RichText _buildLanguageText(BuildContext context) {
    List<InlineSpan> spans = [];

    for (String languageCode in selectedLanguages) {
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: dash_flags.LanguageFlag(
          height: 19,
          language: dash_flags.Language.fromCode(languageCode),
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

  Widget _buildSecondPage(BuildContext context, bool isDarkMode) {
    return SingleChildScrollView(
      controller: _scrollControllerPage2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(S.of(context).tellUsWhatYouAreLookingFor,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontSize: 17)),
          const SizedBox(height: 20),

          Stack(
            children: [
              Scrollbar(
                thumbVisibility: true,
                thickness: 5,
                controller: _scrollControllerPage2,
                child: TextField(
                  scrollPhysics: const ClampingScrollPhysics(),
                  controller: _requestController,
                  decoration: InputDecoration(
                    hintText: S.of(context).requestTextFieldHintText,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 18,
                  enabled: !isSendingRequest &&
                      !_isImprovingTranscription &&
                      !_isAutoWriting,
                ),
              ),

              /// Auto Writting Icon
              Positioned(
                right: 58,
                bottom: 13,
                child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: _isAutoWriting ? _stopAutoWrite : _startAutoWrite,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _isAutoWriting && isDarkMode
                            ? Colors.white24
                            : Colors.transparent,
                        boxShadow: [
                          if (_isAutoWriting)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 0,
                              spreadRadius: 0,
                            ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isAutoWriting
                            ? Icons.auto_awesome
                            : Icons.auto_awesome_outlined,
                        color: (isSendingRequest && !isDarkMode)
                            ? Colors.black54
                            : (isSendingRequest && isDarkMode)
                                ? Colors.white24
                                : (_isAutoWriting && !isDarkMode
                                    ? Colors.yellow
                                    : isDarkMode && _isAutoWriting
                                        ? Colors.white
                                        : isDarkMode && !_isAutoWriting
                                            ? Colors.white.withOpacity(0.7)
                                            : Colors.black.withOpacity(0.7)),
                        size: 28,
                      ),
                    )),
              ),

              /// Record Icon
              Positioned(
                right: 13,
                bottom: 13,
                child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: isSendingRequest
                        ? null
                        : (_isListening ? _stopListening : _startListening),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _isListening ? Colors.red : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: (isSendingRequest && !isDarkMode)
                            ? Colors.black54
                            : (isSendingRequest && isDarkMode)
                                ? Colors.white24
                                : (_isListening && !isDarkMode
                                    ? Colors.white
                                    : isDarkMode && _isListening
                                        ? Colors.white
                                        : isDarkMode && !_isListening
                                            ? Colors.white.withOpacity(0.7)
                                            : Colors.black.withOpacity(0.7)),
                        size: 30,
                      ),
                    )),
              ),
            ],
          ),
          const SizedBox(height: 15),

          if (_tagsResponse != null) ...[
            if (_tagsResponse!.error != null) ...[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ThemeSettings.errorColor.shade50,
                  border: Border.all(
                    color: ThemeSettings.errorColor,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Icon(Icons.warning, color: Colors.red, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        S.of(context).ohNoSomethingWentWrong,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: ThemeSettings.errorColor,
                                ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ErrorCodeToText.getGeminiErrorMessage(
                            _tagsResponse!.error!, context),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: ThemeSettings.errorColor,
                            ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],

          /// Send Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, ThemeSettings.buttonsHeight),
                  ),
                  onPressed: isSendingRequest || _isAutoWriting
                      ? null
                      : _sendUserRequest,
                  child: isSendingRequest
                      ? Text(S.of(context).sendingButton)
                      : _isListening ||
                              _isImprovingTranscription ||
                              _isAutoWriting
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: LoadingCircle(
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.white.withOpacity(0.8),
                              ),
                            )
                          : Text(S.of(context).sendButton)),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  void _showLanguageSelectionModal(
      BuildContext context, List<String> availableLanguages) {
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
                      physics: ClampingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: availableLanguages.map((String languageCode) {
                          return CheckboxListTile(
                            title: Row(
                              children: [
                                dash_flags.LanguageFlag(
                                    height: 20,
                                    language: dash_flags.Language.fromCode(
                                        languageCode)),
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
                              setState(() {
                                _languageController.text =
                                    _getLocalizedLanguageNames(
                                        selectedLanguages);
                              });
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

  Future<Object?> _sendUserRequest() async {
    if (isSendingRequest) return null;
    if (_requestController.text.isEmpty) {
      NotificationSnackbar.showSnackBar(
          message: S.of(context).theRequestInputShouldNotBeEmpty,
          variant: SnackbarVariant.info,
          duration: 'short');
      return null;
    }

    setState(() {
      isSendingRequest = true;
    });
    final inputText = _requestController.text;
    final GeminiTagsResponse geminiResponse =
        await _geminiService.getTherapyTags(inputText);

    if (geminiResponse.tags.positive.isEmpty &&
        geminiResponse.tags.negative.isEmpty) {
      NotificationModal.errorModal(
          context: context,
          title: S.of(context).oops,
          message: S.of(context).noTagsFoundErrorDescription,
          onTapConfirm: () {});
      setState(() {
        isSendingRequest = false;
      });
      return null;
    }

    setState(() {
      _tagsResponse = geminiResponse;
    });

    log(geminiResponse.toJson().toString());

    if (geminiResponse.error != null) {
      setState(() {
        isSendingRequest = false;
      });
      return null;
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AspectsScreen(
            aspects: geminiResponse.tags.toAspects(),
            therapistFilters: therapistFilters,
          ),
        ),
      );
    }

    setState(() {
      isSendingRequest = false;
    });

    return geminiResponse;
  }
}
