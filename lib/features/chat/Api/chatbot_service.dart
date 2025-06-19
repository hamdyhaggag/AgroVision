import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:agro_vision/models/chat_message.dart';
import '../../../models/new_session_request.dart';
import '../../../models/session_response.dart';

part 'chatbot_service.g.dart';

@RestApi(baseUrl: '')
abstract class ChatbotService {
  factory ChatbotService(Dio dio) {
    dio.options.baseUrl = dotenv.env['CHATBOT_BASE_URL'] ??
        'https://immortal-basically-lemur.ngrok-free.app/';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);
    return _ChatbotService(dio);
  }

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
  Future<SessionApiModel> getSessions(@Path('user_id') String userId);
}

class SessionApiModel {
  final String userId;
  final List<SessionData> sessions;

  SessionApiModel({
    required this.userId,
    required this.sessions,
  });

  factory SessionApiModel.fromJson(Map<String, dynamic> json) {
    return SessionApiModel(
      userId: json['user_id'],
      sessions: (json['sessions'] as List)
          .map((session) => SessionData.fromJson(session))
          .toList(),
    );
  }
}

class SessionData {
  final String sessionId;
  final List<String> memory;

  SessionData({
    required this.sessionId,
    required this.memory,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      sessionId: json['session_id'],
      memory: (json['memory'] as List).map((msg) => msg.toString()).toList(),
    );
  }
}
