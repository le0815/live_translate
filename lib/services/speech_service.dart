import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
class SpeechService {  
  static final SpeechService instance = SpeechService._();
  SpeechService._();

  late ServiceAccount serviceAccount;
  late SpeechToText _speechToText;

  void init(){
    log("init speech service");
    serviceAccount = ServiceAccount.fromFile(File(r"C:\Users\thang\Documents\git\live_translate\.env\speech_to_text\flutter-live-translate-a42248ffbe49.json"));    
    _speechToText = SpeechToText.viaServiceAccount(serviceAccount);
  }

  Stream<String> startStream(Stream<Uint8List> audioStream) {
    log("start recognizing");
    final responseStream = _speechToText.streamingRecognize(
      StreamingRecognitionConfig(
        config: RecognitionConfig(
          encoding: AudioEncoding.LINEAR16,
          model: RecognitionModel.basic,
          enableAutomaticPunctuation: true,
          sampleRateHertz: 16000,
          languageCode: 'en-US',
        ),
        interimResults: true,
      ),
      audioStream,
    );

    return responseStream.map((data) {
      final result = data.results
          .map((e) => e.alternatives.first.transcript)
          .join('\n');
      return result;
    });
  }
}
