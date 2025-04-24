import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorder {
  late final RecorderController _recorderController;
  String? _filePath;

  Future<void> init() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) throw Exception('Microphone permission denied');

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
    return _filePath;
  }

  Future<File> convertToWav(File inputFile) async {
    final tempDir = await getTemporaryDirectory();
    final outputPath =
        p.join(tempDir.path, '${DateTime.now().millisecondsSinceEpoch}.wav');

    final session = await FFmpegKit.execute('-y -i "${inputFile.path}" '
        '-acodec pcm_s16le -ar 16000 -ac 1 -f wav "$outputPath"');

    final returnCode = await session.getReturnCode();

    if (returnCode!.isValueSuccess()) {
      return File(outputPath);
    } else {
      throw Exception('Audio conversion failed');
    }
  }

  Future<void> dispose() async {
    _recorderController.dispose();
  }
}
