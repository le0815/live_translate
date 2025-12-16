// import 'dart:io';

// import 'package:desktop_audio_capture/system/system_audio_capture.dart';
// import 'package:google_speech/config/recognition_config.dart';
// import 'package:google_speech/config/recognition_config_v1.dart';
// import 'package:google_speech/config/streaming_recognition_config.dart';
// import 'package:google_speech/speech_client_authenticator.dart';
// import 'package:google_speech/speech_to_text.dart';

// void main(List<String> args) async{
//   ServiceAccount serviceAccount = ServiceAccount.fromFile(
//     File(
//       r"C:\Users\thang\Documents\git\live_translate\.env\speech_to_text\flutter-live-translate-a42248ffbe49.json",
//     ),
//   );

//   final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
//   final config = RecognitionConfig(
//                          encoding: AudioEncoding.LINEAR16,
//                          model: RecognitionModel.basic,
//                          enableAutomaticPunctuation: true,
//                          sampleRateHertz: 16000,
//                          languageCode: 'en-US');

//   final streamingConfig = StreamingRecognitionConfig(config: config, interimResults: true);

//   // final responseStream = speechToText.streamingRecognize(streamingConfig, audio);
//   // Create instance
//   final systemCapture = SystemAudioCapture(
//     config: SystemAudioConfig(
//       sampleRate: 44100,
//       channels: 2,
//     ),
//   );

//   // Start capture
//   await systemCapture.startCapture();

//   // Listen to audio stream
//   systemCapture.audioStream?.listen((audioData) {
//     // Process audio data (Uint8List)
//     print('Received ${audioData.length} bytes');
//   });


                      
// }
