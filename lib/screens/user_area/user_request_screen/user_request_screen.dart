import 'dart:developer';
import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:findatherapistapp/models/general_models.dart';
import 'package:findatherapistapp/providers/locale_provider.dart';
import 'package:findatherapistapp/widgets/NotificationSnackbar/notification_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:findatherapistapp/widgets/LoadingCircle/loading_circle.dart';
import 'package:findatherapistapp/services/gemini_service.dart';
import 'package:findatherapistapp/services/speech_to_text_service.dart';
import '../../../app_settings/theme_settings.dart';
import '../../../models/gemini_tags_response_model.dart';
import '../../../providers/providers_all.dart';
import '../../../utils/debug/error_code_to_text.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../../generated/l10n.dart';
import '../../common/aspects_screen/aspects_screen.dart';

class UserRequestScreen extends ConsumerStatefulWidget {
  const UserRequestScreen({super.key});

  @override
  ConsumerState<UserRequestScreen> createState() => _UserRequestScreenState();
}

class _UserRequestScreenState extends ConsumerState<UserRequestScreen> {
  final TextEditingController _requestController = TextEditingController();
  String _requestLastText = '';
  final GeminiService _geminiService = GeminiService();
  final SpeechToTextService _speechService = SpeechToTextService();
  GeminiTagsResponse? _tagsResponse;
  bool isSendingRequest = false;
  bool _isListening = false;
  bool _isImprovingTranscription = false;
  bool _isAutoWriting = false;
  Timer? _autoWriteTimer;
  TextEditingController controller = TextEditingController();
  UserRequestFilters therapistFilters =
      UserRequestFilters(remote: true, presential: true, country: 'US');
  List<Country> countries = [];
  String listenedText = '';
  CountryService countryService = CountryService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    List<Country> allCountries = countryService.getAll();

    setState(() {
      countries = allCountries;
    });
  }

  void _initializeSpeech() async {
    await _speechService.initialize();
  }

  @override
  void dispose() {
    _speechService.stopListening();
    _requestController.dispose();
    _autoWriteTimer?.cancel();
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

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        ref.watch(themeProvider).themeMode == ThemeMode.dark;
    return AppScaffold(
      setFloatingSpeedDialToLoadingMode:
          isSendingRequest || _isAutoWriting || _isImprovingTranscription,
      scrollPhysics: const ClampingScrollPhysics(),
      useTopAppBar: true,
      isProtected: true,
      appBarTitle: S.of(context).yourRequest,
      body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(S.of(context).tellUsWhatYouAreLookingFor,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 17)),
              const SizedBox(height: 20),
              Stack(
                children: [
                  Scrollbar(
                    // trackVisibility: true,
                    thumbVisibility: true,
                    thickness: 5,
                    controller: _scrollController,
                    child: TextField(
                      scrollPhysics: const ClampingScrollPhysics(),
                      // scrollController: _scrollController,
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
                        onTap:
                            _isAutoWriting ? _stopAutoWrite : _startAutoWrite,
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
                                                : Colors.black
                                                    .withOpacity(0.7)),
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
                            color:
                                _isListening ? Colors.red : Colors.transparent,
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
                                                : Colors.black
                                                    .withOpacity(0.7)),
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

                      /// add warning icon big and centered

                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Icon(Icons.warning,
                              color: Colors.red, size: 40),
                          const SizedBox(height: 10),
                          Text(
                            S.of(context).ohNoSomethingWentWrong,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: ThemeSettings.errorColor,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            ErrorCodeToText.getGeminiErrorMessage(
                                _tagsResponse!.error!, context),
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
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

                                therapistFilters.remote =
                                    !therapistFilters.remote;
                              });
                            },
                            contentPadding:
                                const EdgeInsets.only(left: 25, right: 10),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
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
                            contentPadding:
                                const EdgeInsets.only(left: 24, right: 10),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
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
                  if (therapistFilters.presential)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${S.of(context).country}:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),

                        DropdownButtonFormField<String>(
                          alignment: Alignment.topCenter,
                          menuMaxHeight: 300,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          value: therapistFilters.country,
                          onChanged: (String? countrySelected) {
                            if (countrySelected == null) return;
                            setState(() {
                              therapistFilters.country = countrySelected;
                            });
                          },
                          items: countries
                              .map<DropdownMenuItem<String>>((Country value) {
                            return DropdownMenuItem<String>(
                              value: value.countryCode,
                              child: Text(value.name),
                            );
                          }).toList(),
                        ),

                        /// Insert Google Places AutoComplete Text Field
                        const SizedBox(height: 12),
                      ],
                    ),

                  // TextField(
                  //   onChanged: (value) async {
                  //     Locale locale = Localizations.localeOf(context);
                  //     print(locale.languageCode);
                  //     final places = FlutterGooglePlacesSdk(
                  //         'AIzaSyBxk7_Ie3GXQGueETkWkSMenc2Yw9spiy8',
                  //         locale: locale);
                  //     FindAutocompletePredictionsResponse predictions =
                  //         await places.findAutocompletePredictions('Tel Aviv');
                  //     for (var element in predictions.predictions) {
                  //       print(element);
                  //     }
                  //   },
                  //   decoration: InputDecoration(
                  //     // hintText: S.of(context).country,
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  // Text(
                  //   '${S.of(context).city}:',
                  //   style: Theme.of(context).textTheme.titleMedium,
                  // ),
                  // const SizedBox(height: 10),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     hintText: S.of(context).city,
                  //     border: const OutlineInputBorder(),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 12),

              /// Send Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            const Size(120, ThemeSettings.buttonsHeight),
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
              const SizedBox(height: 90),
            ],
          )),
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
