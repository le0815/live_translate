import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:record/record.dart';

class AudioService {
  static final AudioService instance = AudioService._();
  AudioService._();
  
  final AudioRecorder _audioRecorder = AudioRecorder();
  StreamController<Uint8List>? _audioStreamController;
  StreamSubscription? _recordSubscription;

  Stream<Uint8List> get audioStream => _audioStreamController?.stream ?? Stream.empty();

  Future<void> startRecording() async {
    log("start recording");
    if (await _audioRecorder.hasPermission()) {
      _audioStreamController = StreamController<Uint8List>();
      log("start stream");
      final stream = await _audioRecorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ),
      );

      _recordSubscription = stream.listen((data) {
        _audioStreamController?.add(data);
      });
    }
  }

  Future<void> stopRecording() async {
    log("stop stream");
    await _audioRecorder.stop();
    await _recordSubscription?.cancel();
    await _audioStreamController?.close();
    _audioStreamController = null;
  }
}
