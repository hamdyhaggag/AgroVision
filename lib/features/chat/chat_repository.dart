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

  Future<ChatResponse> sendImage(File image) async {
    final response = await chatbotService.sendImageMessage(image);
    return response;
  }

  Future<ChatResponse> sendVoice(File voiceFile) async {
    final response = await chatbotService.sendVoiceMessage(voiceFile);
    return response;
  }
}
