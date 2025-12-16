import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:desktop_audio_capture/system/system_audio_capture.dart';
import 'package:record/record.dart';

class AudioService {
  static final AudioService instance = AudioService._();
  AudioService._();

  final systemCapture = SystemAudioCapture(
    config: SystemAudioConfig(sampleRate: 44100, channels: 1),
  );
  StreamController<Uint8List>? _audioStreamController;
  StreamSubscription? _recordSubscription;

  Stream<Uint8List> get audioStream =>
      _audioStreamController?.stream ?? Stream.empty();

  Future<Stream<Uint8List>> startRecording() async {
    if (await systemCapture.requestPermissions()) {
      _audioStreamController = StreamController<Uint8List>();
      log("start audio stream");

      await systemCapture.startCapture();
      
      _recordSubscription = systemCapture.audioStream!.listen((data) {
        _audioStreamController?.add(data);
      });  
      
      // Return the actual stream that will receive audio data
      return _audioStreamController!.stream;
    }
    else{
      log("have no sound permission");
      // Return an empty stream if permission is denied
      return Stream.empty();
    }
  }

  Future<void> stopRecording() async {
    log("stop stream");
    await systemCapture.stopCapture();
    await _recordSubscription?.cancel();
    await _audioStreamController?.close();
    _audioStreamController = null;
  }
}
