import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:agro_vision/models/chat_message.dart';
import '../../../models/new_session_request.dart';
import '../../../models/session_response.dart';

part 'chatbot_service.g.dart';

@RestApi(baseUrl: 'https://immortal-basically-lemur.ngrok-free.app/')
abstract class ChatbotService {
  factory ChatbotService(Dio dio) = _ChatbotService;

  @POST('text_convo')
  Future<ChatResponse> sendTextMessage(@Body() ChatRequestBody body);

  @POST('new_session')
  Future<SessionResponse> createNewSession(@Body() NewSessionRequest body);

  @POST('image_convo')
  @MultiPart()
  Future<ChatResponse> sendImageMessage(
    @Part(name: 'image_file') File image,
    @Part(name: 'question') String question,
    @Part(name: 'mode') String mode,
    @Part(name: 'speak') String speak,
    @Part(name: 'user_id') String userId,
    @Part(name: 'session_id') String sessionId,
  );

  @POST('voice_convo')
  @MultiPart()
  Future<ChatResponse> sendVoiceMessage(
    @Part(name: 'audio_file') File voiceFile,
    @Part(name: 'speak') String speak,
    @Part(name: 'language') String language,
    @Part(name: 'user_id') String userId,
    @Part(name: 'session_id') String sessionId,
  );

  @DELETE('delete_session/{user_id}/{session_id}')
  Future<void> deleteSession(
    @Path('user_id') String userId,
    @Path('session_id') String sessionId,
  );

  @GET('sessions/{session_id}')
  Future<SessionApiModel> getSession(@Path('session_id') String sessionId);
  @GET('/sessions/{user_id}')
  Future<List<SessionApiModel>> getSessions(@Path('user_id') String userId);
}

class SessionApiModel {
  final String sessionId;
  final List<Message> messages;
  final String createdAt;
  final String? title;

  SessionApiModel({
    required this.sessionId,
    required this.messages,
    required this.createdAt,
    this.title,
  });

  factory SessionApiModel.fromJson(Map<String, dynamic> json) {
    return SessionApiModel(
      sessionId: json['session_id'],
      messages: (json['messages'] as List)
          .map((msg) => Message.fromJson(msg))
          .toList(),
      createdAt: json['created_at'],
      title: json['title'],
    );
  }
}
