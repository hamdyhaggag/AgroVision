import '../../../../core/network/api_error_handler.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_service.dart';

class LogoutRepo {
  final ApiService _apiService;

  LogoutRepo(this._apiService);

  Future<ApiResult<void>> logout() async {
    try {
      await _apiService
          .logout(); // Assuming the ApiService has a `logout` method
      return const ApiResult.success(null); // Success with no data (void)
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
