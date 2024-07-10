import 'package:findatherapistapp/models/gemini_tags_response.dart';
import 'package:findatherapistapp/widgets/LoadingCircle/loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:findatherapistapp/services/gemini_service.dart';
import '../../../app_settings/theme_settings.dart';
import '../../../utils/ui/is_dark_mode.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../../generated/l10n.dart';

class UserRequestScreen extends ConsumerStatefulWidget {
  const UserRequestScreen({super.key});

  @override
  ConsumerState<UserRequestScreen> createState() => _UserRequestScreenState();
}

class _UserRequestScreenState extends ConsumerState<UserRequestScreen> {
  final TextEditingController _requestController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  GeminiTagsResponse? _tagsResponse;
  bool isSendingRequest = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isProtected: true,
      appBarTitle: 'Request a Therapist',
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${S.of(context).tellUsWhatYouAreLookingFor}:',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
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
            maxLines: 18,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(130, ThemeSettings.buttonsHeight),
                  ),
                  onPressed: _sendRequest,
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
                            side:
                                const BorderSide(color: Colors.red, width: 1.0),
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
            const SizedBox(height: 5),
          ],
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
      isSendingRequest = false;
      _tagsResponse = geminiResponse;
    });

    return geminiResponse;

    print(geminiResponse.toJson());
  }
}
