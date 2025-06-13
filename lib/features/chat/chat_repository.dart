import 'dart:io';
import 'package:dio/dio.dart';
import 'package:agro_vision/features/chat/api/chatbot_service.dart';
import 'package:agro_vision/models/chat_message.dart';
import 'package:flutter/foundation.dart';
import '../../models/chat_session.dart';
import '../../models/new_session_request.dart';
import '../../models/session_response.dart';

class NetworkUnavailableException implements Exception {
  @override
  String toString() => 'Internet connection unavailable';
}

class ServerTimeoutException implements Exception {
  @override
  String toString() => 'Server request timed out. Please try again.';
}

class ServerOfflineException implements Exception {
  @override
  String toString() => 'Server is currently offline. Please try again later.';
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
      if (kDebugMode) {
        print('sendText Response: ${response.answer}');
      } // Log the response
      return response;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('sendText Error: ${e.message}, Response: ${e.response?.data}');
      } // Log the error
      if (_isNetworkError(e)) {
        throw NetworkUnavailableException();
      }
      if (_isTimeoutError(e)) {
        throw ServerTimeoutException();
      }
      if (_isServerOfflineError(e)) {
        throw ServerOfflineException();
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
    try {
      final response = await chatbotService.sendImageMessage(
        image,
        question,
        mode,
        speak,
        userId,
        sessionId,
      );
      if (kDebugMode) {
        print('sendImage Response: ${response.answer}');
      }
      return response;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('sendImage Error: ${e.message}, Response: ${e.response?.data}');
      }
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

  Future<void> deleteSession(String userId, String sessionId) async {
    try {
      await chatbotService.deleteSession(userId, sessionId);
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        throw NetworkUnavailableException();
      }
      throw ChatException('Failed to delete session: ${e.message}');
    }
  }

  Future<List<ChatSession>> getSessions(String userId) async {
    try {
      final response = await chatbotService.getSessions(userId);
      return response.sessions.map((sessionData) {
        final messages = sessionData.memory.map((msg) {
          final isUser = msg.startsWith('User:');
          final text =
              isUser ? msg.substring(5).trim() : msg.substring(10).trim();
          return Message(
            text: text,
            isSentByMe: isUser,
            status: MessageStatus.delivered,
            timestamp: DateTime.now(),
          );
        }).toList();

        return ChatSession(
          id: sessionData.sessionId,
          messages: messages,
          createdAt: DateTime.now(),
          title: messages.isNotEmpty ? messages.first.text : 'New Chat',
        );
      }).toList();
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        throw NetworkUnavailableException();
      }
      if (e.response?.statusCode == 404) {
        throw ChatException('No sessions found for this user');
      }
      throw ChatException('Failed to fetch sessions: ${e.message}');
    }
  }

  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.error is SocketException ||
        (e.error?.toString().contains('Failed host lookup') ?? false) ||
        (e.message?.contains('Connection closed') ?? false);
  }

  bool _isTimeoutError(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout;
  }

  bool _isServerOfflineError(DioException e) {
    return e.response?.statusCode == 503 ||
        e.response?.statusCode == 502 ||
        e.response?.statusCode == 504;
  }
}
