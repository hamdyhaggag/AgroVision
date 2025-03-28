import 'dart:io';
import 'package:dio/dio.dart';
import 'package:agro_vision/features/chat/api/chatbot_service.dart';
import 'package:agro_vision/models/chat_message.dart';

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
        question,
        mode,
        speak,
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Image upload failed: ${e.message}');
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
      throw Exception('Voice upload failed: ${e.message}');
    }
  }
}
