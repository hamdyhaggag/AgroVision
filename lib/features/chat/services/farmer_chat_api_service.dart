import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:agro_vision/features/chat/models/farmer_chat_model.dart';

part 'farmer_chat_api_service.g.dart';

@RestApi(baseUrl: '')
abstract class FarmerChatApiService {
  factory FarmerChatApiService(Dio dio) {
    dio.options.baseUrl = dotenv.env['AGROVISION_CHAT_BASE_URL'] ??
        'http://final.agrovision.ltd/';
    return _FarmerChatApiService(dio);
  }

  @GET('/api/conversations')
  Future<HttpResponse<ConversationsResponse>> getConversations();

  @POST('/api/conversations')
  Future<HttpResponse<Conversation>> createConversation(
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/messages')
  Future<HttpResponse<Message>> sendMessage(
    @Body() Map<String, dynamic> body,
  );
}
