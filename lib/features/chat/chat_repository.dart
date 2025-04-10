import 'dart:io';
import 'package:dio/dio.dart';
import 'package:agro_vision/features/chat/api/chatbot_service.dart';
import 'package:agro_vision/models/chat_message.dart';

import '../authentication/Logic/services/auth_service.dart';
import '../authentication/Logic/services/session_service.dart';
import '../authentication/Logic/services/settings_service.dart';

class NetworkUnavailableException implements Exception {
  @override
  String toString() => 'Internet connection unavailable';
}

class ChatException implements Exception {
  final String message;
  ChatException(this.message);

  @override
  String toString() => message;
}

class ChatRepository {
  final ChatbotService chatbotService;
  final AuthService _authService;
  final SessionService _sessionService;
  final SettingsService _settingsService;

  ChatRepository({
    required this.chatbotService,
    required AuthService authService,
    required SessionService sessionService,
    required SettingsService settingsService,
  })  : _authService = authService,
        _sessionService = sessionService,
        _settingsService = settingsService;

  Future<ChatResponse> sendText(String text) async {
    try {
      final response = await chatbotService.sendTextMessage(
        ChatRequestBody(
          userId: _authService.userId ?? 'unknown',
          sessionId: _sessionService.sessionId,
          query: text,
          speakResponse: _settingsService.speakResponse,
        ),
      );
      return response;
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        throw NetworkUnavailableException();
      }
      if (e.response?.statusCode == 404) {
        throw ChatException(
            'API endpoint not found. Check server configuration');
      }
      throw ChatException('Failed to send message: ${e.message}');
    }
  }

  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout;
  }

  Future<ChatResponse> sendImage(
    File image,
    String question,
    String mode,
    String speak,
  ) async {
    try {
      final response = await chatbotService.sendImageMessage(
        image,
        question,
        mode,
        speak,
      );
      return response;
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        throw NetworkUnavailableException();
      }
      throw ChatException('Image upload failed: ${e.message}');
    }
  }

  Future<ChatResponse> sendVoice(
      File voiceFile, String speak, String language) async {
    try {
      final response = await chatbotService.sendVoiceMessage(
        voiceFile,
        speak,
        language,
      );
      return response;
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        throw NetworkUnavailableException();
      }
      throw ChatException('Voice upload failed: ${e.message}');
    }
  }
}
