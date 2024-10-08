import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import '../app_settings/env_settings.dart';
import '../models/gemini_tags_response_model.dart' as local_models;
import '../services/error_reporting_service.dart';

class GeminiService {
  final String apiKey = EnvSettings.googleGenerativeApiKey;

  final model = FirebaseVertexAI.instance.generativeModel(
    model: 'gemini-1.5-pro-001',
  );

  Future<local_models.GeminiTagsResponse> getTherapyTags(
      String inputText) async {
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
      final response = await model.generateContent([Content.text(prompt)]);

      if (response.text?.isEmpty ?? true) {
        return local_models.GeminiTagsResponse(
          tags: local_models.Tags(positive: [], negative: []),
          error: local_models.GeminiErrorResponse(
            message: 'No text found in response',
            code: 'no-text-found-in-response',
          ),
          candidates: [],
        );
      }

      final responseText = response.text!;

      // Extract only the JSON part of the response
      final jsonString = _extractJson(responseText);
      if (jsonString.isEmpty) {
        return local_models.GeminiTagsResponse(
          tags: local_models.Tags(positive: [], negative: []),
          error: local_models.GeminiErrorResponse(
            message: 'No JSON found in response text',
            code: 'no-json-found-in-response-text',
          ),
          candidates: [],
        );
      }

      final jsonResponse = jsonDecode(jsonString);
      final geminiTagsResponse =
          local_models.GeminiTagsResponse.fromJson(jsonResponse);
      return geminiTagsResponse;
    } catch (e, stackTrace) {
      await ErrorReportingService.reportError(e, stackTrace, null,
          screen: 'GeminiService',
          errorLocation: 'getTherapyTags',
          additionalInfo: [
            'User input text: $inputText',
          ]);
      return local_models.GeminiTagsResponse(
        tags: local_models.Tags(positive: [], negative: []),
        error: local_models.GeminiErrorResponse(
          message: 'Unknown error occurred',
          code: 'unknown-error',
        ),
        candidates: [],
      );
    }
  }

  Future<local_models.GeminiTagsResponse> getAspectsForTherapist(
      String text) async {
    // final model = FirebaseVertexAI.instance.generativeModel(
    //   model: 'gemini-1.5-flash-latest',
    // );

    final promptTemplate = '''
Input Text: {inputText}

Instructions for the AI: Your task is to analyze the provided text and extract key information essential for classifying and understanding the therapist's offerings, services, and limitations. It's important that if the therapist names specific conditions that he or she treats, that you extract them as a tag (e.g., 'anxiety', 'low-self-esteem', 'food-addiction', 'borderline-personality-disorder' or any other condition or type of person that the therapist mentions that he or she DOES treat). Generate a structured object named tags that includes two arrays, positive and negative, to encapsulate:

Convert All Terms to English and Lowercase: Regardless of the input text's language, ensure all extracted terms are translated into English and presented in lowercase. This includes types of therapy, client challenges, and any preferences or characteristics mentioned.
Use Hyphens for Multi-Word Terms: For concepts consisting of more than one word, connect these words with hyphens instead of spaces. Ensure these hyphen-connected terms are also in lowercase to maintain data uniformity and facilitate easier data processing.
Types of Therapy Offered: Identify any specific therapy types mentioned that the therapist can offer (e.g., cbt, jungian-analysis, emdr) and list them under the positive category.
Client Conditions Treated: Extract any conditions or challenges that the therapist treats (e.g., screen-addiction, anxiety, digital-overload, stress, body-image-issues) and place them in the positive array.
Client Preferences and Limitations: Extract any preferences regarding clients or limitations in the therapist's practice (e.g., children, trauma-cases, astrology) and place them in the negative array.
If the therapist mentions he works with astrology and children for example, then you should add 'astrology' and 'child-therapy' to the positive array. If the therapist mentions he does not work with children, then you should add 'child-therapy' and 'astrology' to the negative array.
Therapy Preferences and Other Relevant Details: If the text includes specific preferences regarding therapy modality or other relevant details (like offering-holistic-therapy, not-offering-medication), add these to the appropriate array, using hyphens for two-word terms, and ensure all are in lowercase.
Expected Output: A structured object tags with two arrays, positive and negative, that accurately reflect the key information from the text, correctly formatted in English and entirely in lowercase. This structure aims to facilitate precise matching in a therapy search database.
  ''';

    final publicPrompt = promptTemplate.replaceAll('{inputText}', text);

    try {
      final response =
          await model.generateContent([Content.text(publicPrompt)]);

      if (response.text?.isEmpty ?? true) {
        return local_models.GeminiTagsResponse(
          tags: local_models.Tags(positive: [], negative: []),
          error: local_models.GeminiErrorResponse(
            message: 'No text found in response',
            code: 'no-text-found-in-response',
          ),
          candidates: [],
        );
      }

      final responseText = response.text!;

      // Extract only the JSON part of the response
      final jsonString = _extractJson(responseText);
      if (jsonString.isEmpty) {
        return local_models.GeminiTagsResponse(
          tags: local_models.Tags(positive: [], negative: []),
          error: local_models.GeminiErrorResponse(
            message: 'No JSON found in response text',
            code: 'no-json-found-in-response-text',
          ),
          candidates: [],
        );
      }

      final jsonResponse = jsonDecode(jsonString);
      final geminiTagsResponse =
          local_models.GeminiTagsResponse.fromJson(jsonResponse);
      return geminiTagsResponse;
    } catch (e, stackTrace) {
      await ErrorReportingService.reportError(e, stackTrace, null,
          screen: 'GeminiService',
          errorLocation: 'getAspectsForTherapist',
          additionalInfo: [
            'Text: $text',
          ]);
      return local_models.GeminiTagsResponse(
        tags: local_models.Tags(positive: [], negative: []),
        error: local_models.GeminiErrorResponse(
          message: 'Unknown error occurred',
          code: 'unknown-error',
        ),
        candidates: [],
      );
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
    // final model = FirebaseVertexAI.instance.generativeModel(
    //   model: 'gemini-1.5-flash-latest',
    // );

    final prompt = '''
    Input Text: $text

    Instructions for the AI: This text has been transcribed from an audio input and may contain inaccuracies in punctuation and wording. Your task is to improve the text by correcting any errors and making it more coherent and cohesive. Ensure that the improved text is a faithful representation of what the user intended to say, and correct words if necessary to maintain coherence. And ALWAYS return the text in its original language. If the text is empty or contains no errors, return the original text as is. Never reply anything with your own words or opinions.

    Expected Output: The improved text, well-punctuated and corrected, in a readable format.
    ''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);

      if (response.text?.isEmpty ?? true) {
        return text;
      }

      return response.text ?? text;
    } catch (e) {
      return text;
    }
  }

  Future<String> generateAutoWriteText({required String language}) async {
    String textLanguage = 'english';

    if (language == 'es') {
      textLanguage = 'spanish';
    } else if (language == 'fr') {
      textLanguage = 'french';
    } else if (language == 'de') {
      textLanguage = 'german';
    }

    try {
      // final model = FirebaseVertexAI.instance.generativeModel(
      //   model: 'gemini-1.5-pro-001',
      // );

      final prompt = '''
Generate a detailed therapy request in ${textLanguage} language for an individual looking for a therapist. The request should include personal details (dont write '[your age] [your gender identity] [your race/ethnicity]' don't EVER use brackets, you invent the name and details), specific challenges, and preferences for the therapist and therapy methods. The text should be around not more than 200 characters. You should only write one, not two or three. 

Example: My name is John Doe, and I am a black individual living in Germany. I've been struggling to find a therapist who understands my cultural background and the unique challenges I face. Specifically, I am looking for a black therapist who can relate to my experiences and provide culturally sensitive therapy. I've encountered issues such as racial discrimination, microaggressions, and feelings of isolation. Additionally, I have faced difficulties with anxiety, low self-esteem, and trust issues stemming from past relationships. I am currently very heartbroken due to a recent breakup with my ex, which has exacerbated my feelings of depression and loneliness. Despite my efforts, it has been incredibly difficult to find a black therapist in Germany who meets these criteria.

I have also been experiencing significant stress and burnout from work, which has affected my overall well-being and ability to maintain a healthy work-life balance. My sleep patterns are irregular, often suffering from insomnia, which further impacts my mental health. I've also struggled with body image issues and disordered eating, leading to a negative self-perception and constant worry about my appearance. These compounded issues have made it challenging to engage in social activities, and I often feel socially anxious and withdrawn.

I am interested in therapies that focus on overcoming racial trauma, building self-esteem, and fostering personal growth. I also have a keen interest in astrology, and I find Jungian analysis very insightful. However, my previous experiences with therapy have left me feeling skeptical and uncertain about the effectiveness of traditional methods. I am looking for a therapist who can offer alternative approaches and help me navigate my interest in non-traditional therapeutic practices. I am particularly drawn to therapy sessions that incorporate elements of spirituality and holistic healing. It is crucial for me to find a therapist who can understand and address my multifaceted challenges and provide a compassionate and effective treatment plan.

There are also certain types of therapists and therapeutic approaches I would like to avoid. For instance, I do not want a therapist who strictly follows cognitive-behavioral therapy (CBT), as I have found it too rigid and not in alignment with my needs. I also prefer not to work with a psychiatrist, as I am not looking for medication-based treatment. I am uncomfortable with therapists who focus heavily on psychoanalysis or Freudian theories, as I do not resonate with those methods. Additionally, I would like to avoid therapists who dismiss or are skeptical of holistic and spiritual approaches to mental health. It is also important to me that my therapist does not have a clinical, impersonal approach, as I value a more empathetic and personalized therapeutic relationship.
    ''';

      final response = await model.generateContent([Content.text(prompt)]);
      print('Response: ${response.text}');

      if (response.text?.isEmpty ?? true) {
        return '';
      }

      return response.text ?? '';
    } catch (e, stackTrace) {
      await ErrorReportingService.reportError(e, stackTrace, null,
          screen: 'GeminiService',
          errorLocation: 'getAspectsForTherapist',
          additionalInfo: []);
      debugPrint('Error generating auto write text: $e');
      return '';
    }
  }
}
