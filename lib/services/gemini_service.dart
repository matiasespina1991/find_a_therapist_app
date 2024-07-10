import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import '../app_settings/env_settings.dart';
import '../models/gemini_tags_response.dart';

class GeminiService {
  final String apiKey = EnvSettings.googleGenerativeApiKey;

  Future<GeminiTagsResponse> getTherapyTags(String inputText) async {
    final model = GenerativeModel(
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

    final Iterable<Content> content = [Content.text(prompt)];
    final GenerateContentResponse response =
        await model.generateContent(content);

    String? responseText = response.text;

    if (responseText == null) {
      return GeminiTagsResponse(
          tags: Tags(positive: [], negative: []),
          error: 'No response text from the model');
    }

    responseText =
        responseText.replaceAll('```json', '').replaceAll('```', '').trim();

    try {
      final jsonResponse = jsonDecode(responseText);
      return GeminiTagsResponse.fromJson(jsonResponse);
    } catch (e) {
      return GeminiTagsResponse(
          tags: Tags(positive: [], negative: []),
          error: 'Error parsing response text: $e');
    }
  }
}
