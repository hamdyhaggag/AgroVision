import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorder {
  late final RecorderController _recorderController;
  late final FlutterSoundRecorder _flutterSoundRecorder;
  String? _filePath;

  Future<void> init() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) throw Exception('Microphone permission denied');

    _flutterSoundRecorder = FlutterSoundRecorder();
    await _flutterSoundRecorder.openRecorder();

    _recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100
      ..bitRate = 128000;
  }

  Future<String?> startRecording() async {
    final tempDir = await getTemporaryDirectory();
    _filePath =
        p.join(tempDir.path, '${DateTime.now().millisecondsSinceEpoch}.m4a');
    await _recorderController.record(path: _filePath);
    return _filePath;
  }

  Future<String?> stopRecording() async {
    await _recorderController.stop();
    await Future.delayed(const Duration(milliseconds: 500));
    if (_filePath != null) {
      final m4aFile = File(_filePath!);
      try {
        final wavFile = await convertToWav(m4aFile);
        _filePath = wavFile.path;
        return wavFile.path;
      } catch (e) {
        if (kDebugMode) {
          print('Conversion failed: $e');
        }
        return null;
      }
    }
    return null;
  }

  Future<File> convertToWav(File inputFile) async {
    final tempDir = await getTemporaryDirectory();
    final outputPath =
        p.join(tempDir.path, '${DateTime.now().millisecondsSinceEpoch}.wav');

    try {
      await _flutterSoundRecorder.startRecorder(
        toFile: outputPath,
        codec: Codec.pcm16WAV,
        numChannels: 1,
        sampleRate: 44100,
      );

      // Read the input file and write it to the output file
      final bytes = await inputFile.readAsBytes();
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(bytes);

      await _flutterSoundRecorder.stopRecorder();
      return outputFile;
    } catch (e) {
      if (kDebugMode) {
        print('Audio conversion error: $e');
      }
      throw Exception('Audio conversion failed: $e');
    }
  }

  Future<void> dispose() async {
    _recorderController.dispose();
    await _flutterSoundRecorder.closeRecorder();
  }
}
