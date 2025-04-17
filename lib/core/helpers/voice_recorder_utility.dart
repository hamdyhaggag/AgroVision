import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorder {
  final RecorderController _recorderController = RecorderController();
  String? _filePath;

  Future<void> init() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception('Microphone permission not granted');
    }
  }

  Future<String?> startRecording() async {
    final tempDir = await getTemporaryDirectory();
    _filePath = p.join(tempDir.path, 'voice.wav');
    await _recorderController.record(path: _filePath);
    return _filePath;
  }

  Future<String?> stopRecording() async {
    await _recorderController.stop();
    await Future.delayed(const Duration(milliseconds: 500));
    return _filePath;
  }

  Future<void> dispose() async {
    _recorderController.dispose();
  }
}
