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
      // Add detailed logging for Dio errors
      print('❌ DioException: ${e.message}');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      print('❌ Error Type: ${e.type}');

      if (e.response?.statusCode == 500) {
        return ApiResult.failure(ErrorHandler.handle(e));
      }
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (error, stackTrace) {
      // Log unexpected errors
      print('❌ Unexpected Error: $error');
      print('❌ Stack Trace: $stackTrace');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
