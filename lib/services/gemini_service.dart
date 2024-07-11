import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;
import 'dart:convert';
import '../app_settings/env_settings.dart';
import '../models/gemini_tags_response_model.dart';
import '../services/error_reporting_service.dart';

class GeminiService {
  final String apiKey = EnvSettings.googleGenerativeApiKey;

  Future<GeminiTagsResponse> getTherapyTags(String inputText) async {
    final model = google_ai.GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final prompt = '''
Input Text: $inputText

Instructions for the AI: Your task is to analyze the provided text and extract key information essential for classifying and understanding the individual's therapeutic needs. Generate a structured object named tags that includes two arrays, positive and negative, to encapsulate:

Convert All Terms to English and Lowercase: Regardless of the input text's language, ensure all extracted terms are translated into English and presented in lowercase. This includes types of therapy, personal challenges, and any preferences or characteristics mentioned.
Use Hyphens for Multi-Word Terms: For concepts consisting of more than one word, connect these words with hyphens instead of spaces. Ensure these hyphen-connected terms are also in lowercase to maintain data uniformity and facilitate easier data processing.
Types of Therapy Mentioned: Identify any specific therapy types mentioned (e.g., cbt, jungian-analysis, emdr) and list them under the appropriate category based on the individual's explicit preference for or against them.
Personal Challenges: Extract personal challenges or issues mentioned (such as low-self-esteem, stress-triggered-depressive-episodes) and convert them into atomized, hyphen-connected terms in lowercase. Place them in the 'positive' array if the individual seeks help for these issues.
Therapy Preferences and Other Relevant Details: If the text includes specific preferences regarding therapy modality or other relevant details (like interest in astrology, seeking personal-growth), add these to the 'positive' array, using hyphens for two-word terms, and ensure all are in lowercase.
Expected Output: A structured object tags with two arrays, positive and negative, that accurately reflect the key information from the text, correctly formatted in English and entirely in lowercase. This structure aims to facilitate precise matching in a therapy search database.
    ''';

    try {
      final Iterable<google_ai.Content> content = [
        google_ai.Content.text(prompt),
      ];
      final google_ai.GenerateContentResponse response =
          await model.generateContent(content);

      if (response.candidates.isEmpty) {
        return GeminiTagsResponse(
            tags: Tags(positive: [], negative: []),
            error: GeminiErrorResponse(
                message: 'No candidates found in response',
                code: 'no-candidates'),
            candidates: []);
      }

      String? responseText;
      for (var candidate in response.candidates) {
        if (candidate.text != null && candidate.text!.isNotEmpty) {
          responseText = candidate.text;
          break;
        }
      }

      if (responseText == null) {
        return GeminiTagsResponse(
            tags: Tags(positive: [], negative: []),
            error: GeminiErrorResponse(
                message: 'No text found in response candidates',
                code: 'no-text-found-in-response'),
            candidates: response.candidates
                    .map((candidate) => Candidate(
                          text: candidate.text,
                          safetyRatings: candidate.safetyRatings
                              ?.map((rating) => SafetyRating(
                                    category: rating.category.toString(),
                                    probability: rating.probability.toString(),
                                  ))
                              .toList(),
                        ))
                    .toList() ??
                []);
      }

      // Extract only the JSON part of the response
      final jsonString = _extractJson(responseText);
      if (jsonString.isEmpty) {
        return GeminiTagsResponse(
            tags: Tags(positive: [], negative: []),
            error: GeminiErrorResponse(
                message: 'No JSON found in response text',
                code: 'no-json-found-in-response-text'),
            candidates: response.candidates
                    .map((candidate) => Candidate(
                          text: candidate.text,
                          safetyRatings: candidate.safetyRatings
                              ?.map((rating) => SafetyRating(
                                    category: rating.category.toString(),
                                    probability: rating.probability.toString(),
                                  ))
                              .toList(),
                        ))
                    .toList() ??
                []);
      }

      final jsonResponse = jsonDecode(jsonString);
      final geminiTagsResponse = GeminiTagsResponse.fromJson(jsonResponse);
      geminiTagsResponse.candidates
          ?.addAll(response.candidates.map((candidate) => Candidate(
                text: candidate.text,
                safetyRatings: candidate.safetyRatings
                    ?.map((rating) => SafetyRating(
                          category: rating.category.toString(),
                          probability: rating.probability.toString(),
                        ))
                    .toList(),
              )));
      return geminiTagsResponse;
    } on google_ai.GenerativeAIException catch (e, stackTrace) {
      await ErrorReportingService.reportError(e, stackTrace, null,
          screen: 'GeminiService',
          errorLocation: 'getTherapyTags',
          additionalInfo: [
            'User input text: $inputText',
          ]);

      if (e.message == 'Candidate was blocked due to safety') {
        return GeminiTagsResponse(
            tags: Tags(positive: [], negative: []),
            error: GeminiErrorResponse(
              message: e.message,
              code: 'candidate-blocked-due-to-safety',
            ),
            candidates: []);
      }

      return GeminiTagsResponse(
          tags: Tags(positive: [], negative: []),
          error: GeminiErrorResponse(
            message: e.message,
            code: 'generative-ai-error',
          ),
          candidates: []);
    } catch (e, stackTrace) {
      await ErrorReportingService.reportError(e, stackTrace, null,
          screen: 'GeminiService',
          errorLocation: 'getTherapyTags',
          additionalInfo: [
            'User input text: $inputText',
          ]);
      return GeminiTagsResponse(
          tags: Tags(positive: [], negative: []),
          error: GeminiErrorResponse(
            message: 'Unknown error occurred',
            code: 'unknown-error',
          ),
          candidates: []);
    }
  }

  String _extractJson(String responseText) {
    final regex = RegExp(r'\{.*\}', dotAll: true);
    final match = regex.firstMatch(responseText);
    if (match != null) {
      return match.group(0) ?? '';
    } else {
      return '';
    }
  }

  Future<String> improveTranscription(String text) async {
    final model = google_ai.GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final prompt = '''
    Input Text: $text

    Instructions for the AI: This text has been transcribed from an audio input and may contain inaccuracies in punctuation and wording. Your task is to improve the text by correcting any errors and making it more coherent and cohesive. Ensure that the improved text is a faithful representation of what the user intended to say, and correct words if necessary to maintain coherence. And ALWAYS return the text in its original language. If the text is empty or contains no errors, return the original text as is. Never reply anything with your own words or opinions.

    Expected Output: The improved text, well-punctuated and corrected, in a readable format.
    ''';

    try {
      final Iterable<google_ai.Content> content = [
        google_ai.Content.text(prompt),
      ];
      final google_ai.GenerateContentResponse response =
          await model.generateContent(content);

      if (response.candidates.isEmpty) {
        return text;
      }

      String? responseText;
      for (var candidate in response.candidates) {
        if (candidate.text != null && candidate.text!.isNotEmpty) {
          responseText = candidate.text;
          break;
        }
      }

      return responseText ?? text;
    } catch (e) {
      return text;
    }
  }
}
