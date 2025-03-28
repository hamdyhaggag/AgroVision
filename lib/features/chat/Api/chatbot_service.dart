import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:agro_vision/models/chat_message.dart';

part 'chatbot_service.g.dart';

@RestApi(baseUrl: 'https://e4ce-197-48-37-106.ngrok-free.app/')
abstract class ChatbotService {
  factory ChatbotService(Dio dio) = _ChatbotService;

  @POST('text_convo')
  Future<ChatResponse> sendTextMessage(@Body() ChatRequestBody body);

  @POST('image_convo')
  @MultiPart()
  Future<ChatResponse> sendImageMessage(
    @Part(name: 'image_file') File image,
    @Part(name: 'question') String question,
    @Part(name: 'mode') String mode,
    @Part(name: 'speak') String speak,
  );

  @POST('voice_convo')
  @MultiPart()
  Future<ChatResponse> sendVoiceMessage(
    @Part(name: 'audio_file') File voiceFile,
    @Part(name: 'speak') String speak,
    @Part(name: 'language') String language,
  );
}
