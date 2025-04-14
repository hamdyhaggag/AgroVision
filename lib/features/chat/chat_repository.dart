import 'dart:io';
import 'package:dio/dio.dart';
import 'package:agro_vision/features/chat/api/chatbot_service.dart';
import 'package:agro_vision/models/chat_message.dart';

import '../../models/new_session_request.dart';
import '../../models/session_response.dart';

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

  ChatRepository({required this.chatbotService});

  Future<ChatResponse> sendText(ChatRequestBody body) async {
    try {
      final response = await chatbotService.sendTextMessage(body);

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

  Future<SessionResponse> createNewSession(String userId) async {
    try {
      return await chatbotService.createNewSession(NewSessionRequest(userId));
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        throw NetworkUnavailableException();
      }
      throw ChatException('Failed to create session: ${e.message}');
    }
  }

  Future<ChatResponse> sendImage(
    File image,
    String question,
    String mode,
    String speak,
    String sessionId,
    String userId,
  ) async {
    const String userId = "55";
    try {
      final response = await chatbotService.sendImageMessage(
        image,
        question,
        mode,
        speak,
        userId,
        sessionId,
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
      File voiceFile,
      String speak,
      String language,
      String userId,
      String sessionId,
      ) async {
    try {
      final response = await chatbotService.sendVoiceMessage(
        voiceFile,
        speak,
        language,
        userId,
        sessionId,
      );
      return response;
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        throw NetworkUnavailableException();
      }
      throw ChatException('Voice upload failed: ${e.message}');
    }
  }

  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.error is SocketException ||
        (e.error?.toString().contains('Failed host lookup') ?? false) ||
        (e.message?.contains('Connection closed') ?? false);
  }
}
