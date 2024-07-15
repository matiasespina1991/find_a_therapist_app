import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:findatherapistapp/widgets/LoadingCircle/loading_circle.dart';
import 'package:findatherapistapp/services/gemini_service.dart';
import 'package:findatherapistapp/services/speech_to_text_service.dart';
import '../../../app_settings/theme_settings.dart';
import '../../../models/gemini_tags_response_model.dart';
import '../../../models/therapist_model.dart';
import '../../../providers/providers_all.dart';
import '../../../utils/debug/error_code_to_text.dart';
import '../../../utils/ui/is_dark_mode.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../../generated/l10n.dart';
import '../../../utils/admin/find_best_therapist_by_aspects.dart';
import '../therapist_result_screen/therapist_result_screen.dart';

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
    super.dispose();
  }

  void _startListening() async {
    var localeService = ref.watch(localeProvider);

    setState(() {
      _isListening = true;
      _requestLastText = _requestController.text;
    });

    _speechService.startListening(
      localeId: localeService.locale.languageCode,
      onResult: (text) {
        setState(() {
          _requestController.text = _requestLastText + text;
        });
      },
    );
  }

  void _stopListening() async {
    _speechService.stopListening();
    setState(() => _isListening = false);

    if (_requestController.text.isNotEmpty) {
      await _improveTranscription(_requestController.text);
    }
  }

  Future<void> _improveTranscription(String text) async {
    setState(() {
      isSendingRequest = true;
    });
    final improvedText = await _geminiService.improveTranscription(text);
    setState(() {
      _requestController.text = improvedText;
      isSendingRequest = false;
      _requestLastText = improvedText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      useTopAppBar: true,
      isProtected: true,
      showScreenTitleInAppBar: false,
      appBarTitle: 'Request a Therapist',
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${S.of(context).tellUsWhatYouAreLookingFor}:',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          Stack(
            children: [
              TextField(
                controller: _requestController,
                decoration: InputDecoration(
                  hintText: S.of(context).requestTextFieldHintText,
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      ),
                  border: const OutlineInputBorder(),
                ),
                maxLines: isSendingRequest ? 5 : 18,
                enabled: !isSendingRequest,
              ),
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
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening && !isDarkMode(context)
                            ? Colors.white
                            : null,
                        size: 30,
                      ),
                    )),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(130, ThemeSettings.buttonsHeight),
                  ),
                  onPressed: isSendingRequest ? null : _sendRequest,
                  child: isSendingRequest
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: LoadingCircle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : Text(S.of(context).sendButton)),
            ],
          ),
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
            if (_tagsResponse!.error == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          S.of(context).positiveAspectsTitle,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '(${S.of(context).positiveAspectsDescription})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: _tagsResponse!.tags.positive.isNotEmpty
                        ? _tagsResponse!.tags.positive
                            .map((aspect) => Chip(
                                  side: const BorderSide(
                                      color: Colors.green, width: 1.0),
                                  label: Text(aspect,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: isDarkMode(context)
                                                ? Colors.green
                                                : Colors.white,
                                          )),
                                  backgroundColor: isDarkMode(context)
                                      ? Colors.transparent
                                      : Colors.green.shade400,
                                ))
                            .toList()
                        : [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 13.0),
                              child: Text(S.of(context).notFound,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                          ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  Text(
                    S.of(context).negativeAspectsTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '(${S.of(context).negativeAspectsDescription})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: _tagsResponse!.tags.negative.isNotEmpty
                        ? _tagsResponse!.tags.negative
                            .map((aspect) => Chip(
                                  side: const BorderSide(
                                      color: Colors.red, width: 1.0),
                                  label: Text(aspect,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: isDarkMode(context)
                                                ? Colors.red
                                                : Colors.white,
                                          )),
                                  backgroundColor: isDarkMode(context)
                                      ? Colors.transparent
                                      : Colors.red.shade400,
                                ))
                            .toList()
                        : [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 13.0),
                              child: Text(S.of(context).notFound,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                          ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                ],
              ),
          ],
          const SizedBox(height: 60),
        ],
      )),
    );
  }

  Future<GeminiTagsResponse?> _sendRequest() async {
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

    if (geminiResponse.tags.positive.isNotEmpty ||
        geminiResponse.tags.negative.isNotEmpty) {
      final matchedTherapists =
          await findBestTherapist(geminiResponse.tags.toAspects());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TherapistResultsScreen(matchedTherapists: matchedTherapists),
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
