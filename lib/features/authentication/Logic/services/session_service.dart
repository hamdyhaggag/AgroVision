import 'package:uuid/uuid.dart';

class SessionService {
  String? _sessionId;

  String get sessionId {
    _sessionId ??= const Uuid().v4();
    return _sessionId!;
  }

  void resetSession() {
    _sessionId = null;
  }
}
