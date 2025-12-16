import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';

class SpeechService {
  static final SpeechService instance = SpeechService._();
  SpeechService._();

  late ServiceAccount serviceAccount;
  late SpeechToText _speechToText;
  String curLangCode = "";
  void init() {
    log("init speech service");
    serviceAccount = ServiceAccount.fromFile(
      File(
        r"C:\Users\thang\Documents\git\live_translate\.env\speech_to_text\flutter-live-translate-a42248ffbe49.json",
      ),
    );
    _speechToText = SpeechToText.viaServiceAccount(serviceAccount);
  }

  Stream<String> startStream({
    required Stream<Uint8List> audioStream,
    required String languageCode,
  }) {
    log("start recognizing");
    // final responseStream;
    try {
      final responseStream = _speechToText.streamingRecognize(
        StreamingRecognitionConfig(
          config: RecognitionConfig(
            encoding: AudioEncoding.LINEAR16,
            model: RecognitionModel.latest_long,
            enableAutomaticPunctuation: true,
            sampleRateHertz: 44100,
            languageCode: languageCode,
            
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
    } catch (e) {
      log("Got error while recognizing: $e");
      return Stream.error("Got error while recognizing: $e");
    }    
  }

  void stopStream() {
    _speechToText.dispose();
  }
}
