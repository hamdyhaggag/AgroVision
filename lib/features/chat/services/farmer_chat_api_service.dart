// farmer_chat_api_service.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:agro_vision/features/chat/models/farmer_chat_model.dart';

part 'farmer_chat_api_service.g.dart';

@RestApi(baseUrl: 'http://127.0.0.1:8000/')
abstract class FarmerChatApiService {
  factory FarmerChatApiService(Dio dio, {String baseUrl}) =
      _FarmerChatApiService;

  @GET('/api/conversations')
  Future<HttpResponse<List<Conversation>>> getConversations();

  @POST('/api/conversations')
  Future<HttpResponse<Conversation>> createConversation(
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/messages')
  Future<HttpResponse<Message>> sendMessage(
    @Body() Map<String, dynamic> body,
  );
}
