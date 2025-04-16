import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/authentication/Data/model/login_request_body.dart';
import '../../features/authentication/Data/model/login_response.dart';
import '../../features/authentication/Data/model/message_read_response.dart';
import '../../features/chat/models/farmer_chat_model.dart';
import '../../models/orders_response.dart';
import 'api_constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('users/{user_id}/orders')
  Future<HttpResponse<ApiOrdersResponse>> getUserOrders(
    @Path('user_id') int userId, {
    @Query('page') int? page,
    @Query('status') String? status,
    @Query('search') String? search,
  });

  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequestBody loginRequestBody);

  @POST(ApiConstants.logout)
  Future<void> logout();

//
// @POST(ApiConstants.send)
// Future<ForgotResponseBody> forgot(
//   @Body() ForgotRequestBody forgotRequestBody,
// );
//
// @POST(ApiConstants.resend)
// Future<ResetPasswordResponseBody> reset(
//   @Body() ResetPasswordRequestBody resetPasswordRequestBody,
// );
//
// @POST(ApiConstants.verify)
// Future<VerifyResponseBody> verify(
//   @Body() VerifyRequestBody verifyRequestBody,
// );
//
// @POST(ApiConstants.newPass)
// Future<NewPasswordResponseBody> newPassword(
//   @Body() NewPasswordRequestBody newPasswordRequestBody,
// );
  @POST('/api/conversations')
  Future<HttpResponse<Conversation>> createConversation(
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/messages')
  Future<HttpResponse<Message>> sendMessage(
    @Body() Map<String, dynamic> body,
  );

  @GET('/api/conversations')
  Future<HttpResponse<List<Conversation>>> getConversations();

  @POST('/api/messages/read/{messageId}')
  Future<HttpResponse<MessageReadResponse>> markMessageAsRead(
    @Path('messageId') int messageId,
  );
}
