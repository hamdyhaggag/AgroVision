import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/authentication/Data/model/login_request_body.dart';
import '../../features/authentication/Data/model/login_response.dart';
import 'api_constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

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
}
