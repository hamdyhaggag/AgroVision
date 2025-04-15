import 'package:dio/dio.dart';

import '../../../core/network/api_error_handler.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/api_service.dart';
import '../../../models/api_order.dart';

class OrdersRepo {
  final ApiService _apiService;

  OrdersRepo(this._apiService);

  Future<ApiResult<List<ApiOrder>>> getUserOrders(int userId) async {
    try {
      final response = await _apiService.getUserOrders(userId);
      return ApiResult.success(response.data.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        return ApiResult.failure(
            'Server error: ${e.response?.data}' as ErrorHandler);
      }
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
