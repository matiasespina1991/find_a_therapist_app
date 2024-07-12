import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  Future<bool> initialize() async {
    return await _speech.initialize();
  }

  void startListening({String? localeId, required Function(String) onResult}) {
    _speech.listen(
      localeId: localeId,
      onResult: (val) => onResult(val.recognizedWords),
    );
  }

  void stopListening() {
    _speech.stop();
  }

  bool get isListening => _speech.isListening;
}
