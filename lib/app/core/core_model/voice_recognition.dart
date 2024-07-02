import 'package:speech_to_text/speech_to_text.dart';

class VoiceRecognition {
  final SpeechToText _speechToText = SpeechToText();

  bool get isListening => _speechToText.isListening;
  String lastWords = '';

  Future<void> initSpeech() async {
    await _speechToText.initialize();
  }

  Future<void> startListening(void Function(String) onResult) async {
    await _speechToText.listen(
      onResult: (result) {
        lastWords = result.recognizedWords;
        onResult(lastWords);
      },
    );
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }
}
