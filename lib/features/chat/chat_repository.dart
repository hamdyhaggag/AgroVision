import 'dart:io';
import 'package:dio/dio.dart';
import 'package:agro_vision/features/chat/api/chatbot_service.dart';
import 'package:agro_vision/models/chat_message.dart';
import 'package:flutter/foundation.dart';

class ChatRepository {
  final ChatbotService chatbotService;

  ChatRepository({required this.chatbotService});

  Future<ChatResponse> sendText(String text) async {
    try {
      final response =
          await chatbotService.sendTextMessage(ChatRequestBody(query: text));
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('API endpoint not found. Check server configuration');
      }
      throw Exception('Failed to send message: ${e.message}');
    }
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
        question, // 2nd
        mode, // 3rd
        speak, // 4th
      );
      return response;
    } on DioException catch (e) {
      // Add detailed error logging if desired
      throw Exception('Image upload failed: ${e.message}');
    }
  }

  Future<ChatResponse> sendVoice(File voiceFile) async {
    final response = await chatbotService.sendVoiceMessage(voiceFile);
    return response;
  }
}
