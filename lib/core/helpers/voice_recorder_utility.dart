import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorder {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isInitialized = false;

  Future<void> init() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _recorder.openRecorder();
    _isInitialized = true;
  }

  Future<String?> startRecording() async {
    if (!_isInitialized) await init();
    final tempDir = await getTemporaryDirectory();
    final filePath = p.join(tempDir.path, 'voice.wav');
    await _recorder.startRecorder(
      toFile: filePath,
      codec: Codec.pcm16WAV,
      sampleRate: 16000,
    );
    return filePath;
  }

  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
    final recordedFile = File(await _recorder.stopRecorder() ?? '');
    bool exists = await recordedFile.exists();
    if (kDebugMode) {
      print("Recorded file exists: $exists, path: ${recordedFile.path}");
    }
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
    _isInitialized = false;
  }
}
