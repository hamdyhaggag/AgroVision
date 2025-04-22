import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
      if (kDebugMode) {
        print('❌ DioException: ${e.message}');
      }
      if (kDebugMode) {
        print('❌ Status Code: ${e.response?.statusCode}');
      }
      if (kDebugMode) {
        print('❌ Response Data: ${e.response?.data}');
      }
      if (kDebugMode) {
        print('❌ Error Type: ${e.type}');
      }

      if (e.response?.statusCode == 500) {
        return ApiResult.failure(ErrorHandler.handle(e));
      }
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('❌ Unexpected Error: $error');
      }
      if (kDebugMode) {
        print('❌ Stack Trace: $stackTrace');
      }
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
