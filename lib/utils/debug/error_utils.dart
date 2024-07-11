import 'package:flutter/cupertino.dart';

import '../../models/gemini_tags_response_model.dart';
import '../../../generated/l10n.dart';

class ErrorUtils {
  static String getGeminiErrorMessage(GeminiError error, BuildContext context) {
    switch (error.code) {
      case 'candidate-blocked-due-to-safety':
        return S.of(context).candidateBlockedDueToSafetyMessage;
      case 'no-candidates':
        return S.of(context).noCandidatesMessage;
      case 'no-text-found-in-response':
        return S.of(context).noTextFoundInResponseMessage;
      case 'no-json-found-in-response-text':
        return S.of(context).noJsonFoundInResponseTextMessage;
      case 'generative-ai-error':
        return S.of(context).generativeAiErrorMessage;
      case 'unknown-error':
      default:
        return S.of(context).unknownErrorMessage;
    }
  }
}
