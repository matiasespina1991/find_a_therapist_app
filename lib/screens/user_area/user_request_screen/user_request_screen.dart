import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:findatherapistapp/widgets/LoadingCircle/loading_circle.dart';
import 'package:findatherapistapp/services/gemini_service.dart';
import 'package:findatherapistapp/services/speech_to_text_service.dart';
import '../../../app_settings/theme_settings.dart';
import '../../../models/gemini_tags_response_model.dart';
import '../../../providers/providers_all.dart';
import '../../../utils/debug/error_code_to_text.dart';
import '../../../utils/ui/is_dark_mode.dart';
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
  bool remoteChecked = true;
  bool presentialChecked = true;

  String listenedText = '';

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
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

    final localeService = ref.read(localeProvider);

    final newText = await _geminiService.generateAutoWriteText(
        language: localeService.locale.languageCode);
    int charIndex = 0;

    _autoWriteTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (_isAutoWriting && charIndex < newText.length) {
        setState(() {
          _requestController.text += newText[charIndex];
        });
        charIndex++;
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
    return AppScaffold(
      scrollPhysics: const ClampingScrollPhysics(),
      useTopAppBar: true,
      isProtected: true,
      appBarTitle: S.of(context).yourRequest,
      body: SingleChildScrollView(
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
              TextField(
                controller: _requestController,
                decoration: InputDecoration(
                  hintText: S.of(context).requestTextFieldHintText,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 18,
                enabled: !isSendingRequest ||
                    !_isImprovingTranscription ||
                    !_isAutoWriting,
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
                        color: _isAutoWriting && isDarkMode(context)
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
                      child: isSendingRequest
                          ? const SizedBox()
                          : Icon(
                              _isAutoWriting
                                  ? Icons.auto_awesome
                                  : Icons.auto_awesome_outlined,
                              color: _isAutoWriting && !isDarkMode(context)
                                  ? Colors.yellow
                                  : isDarkMode(context) && _isAutoWriting
                                      ? Colors.white
                                      : isDarkMode(context) && !_isAutoWriting
                                          ? Colors.white.withOpacity(0.7)
                                          : Colors.black.withOpacity(0.7),
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
                    onTap: _isListening ? _stopListening : _startListening,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _isListening ? Colors.red : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: isSendingRequest
                          ? const SizedBox()
                          : Icon(
                              _isListening ? Icons.mic : Icons.mic_none,
                              color: _isListening && !isDarkMode(context)
                                  ? Colors.white
                                  : isDarkMode(context) && _isListening
                                      ? Colors.white
                                      : isDarkMode(context) && !_isListening
                                          ? Colors.white.withOpacity(0.7)
                                          : Colors.black.withOpacity(0.7),
                              size: 30,
                            ),
                    )),
              ),
            ],
          ),
          const SizedBox(height: 15),

          if (_tagsResponse != null) ...[
            if (_tagsResponse!.error != null) ...[
              const SizedBox(height: 15),
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
              )
            ],
          ],

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${S.of(context).meetingType}:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                        onTap: () {
                          setState(() {
                            if (!presentialChecked) return;

                            remoteChecked = !remoteChecked;
                          });
                        },
                        contentPadding:
                            const EdgeInsets.only(left: 25, right: 10),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 2,
                            color: Theme.of(context).dividerColor,
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
                              value: remoteChecked, onChanged: (value) {}),
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ListTile(
                        onTap: () {
                          setState(() {
                            if (!remoteChecked) return;
                            presentialChecked = !presentialChecked;
                          });
                        },
                        contentPadding:
                            const EdgeInsets.only(left: 25, right: 10),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 2,
                            color: Theme.of(context).dividerColor,
                          ),
                          borderRadius: ThemeSettings.buttonsBorderRadius,
                        ),
                        title: Text(S.of(context).presential,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 15)),
                        trailing: IgnorePointer(
                          child: Checkbox(
                              value: presentialChecked, onChanged: (value) {}),
                        )),
                  ),
                ],
              ),

              /// add country and city input in a column
              // const SizedBox(height: 20),
              // Text(
              //   '${S.of(context).country}:',
              //   style: Theme.of(context).textTheme.titleMedium,
              // ),
              // const SizedBox(height: 10),
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: S.of(context).country,
              //     border: const OutlineInputBorder(),
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
                    minimumSize: const Size(120, ThemeSettings.buttonsHeight),
                  ),
                  onPressed: isSendingRequest ? null : _sendUserRequest,
                  child: isSendingRequest ||
                          _isImprovingTranscription ||
                          _isAutoWriting
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: LoadingCircle(
                            color: isDarkMode(context)
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

    setState(() {
      isSendingRequest = true;
    });
    final inputText = _requestController.text;
    final GeminiTagsResponse geminiResponse =
        await _geminiService.getTherapyTags(inputText);

    setState(() {
      _tagsResponse = geminiResponse;
    });

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AspectsScreen(
            aspects: geminiResponse.tags.toAspects(),
          ),
        ),
      );
    }

    setState(() {
      isSendingRequest = false;
    });

    log(geminiResponse.toJson().toString());

    return geminiResponse;
  }
}
