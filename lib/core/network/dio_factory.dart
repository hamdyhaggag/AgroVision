import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../helpers/cache_helper.dart';
import '../routing/app_router.dart';
import '../routing/app_routes.dart';
import 'api_constants.dart';

class DioFactory {
  static Dio getDio() {
    return Dio(BaseOptions(
      baseUrl: 'https://api.openweathermap.org/data/2.5',
      queryParameters: {'appid': dotenv.get('OPENWEATHER_API_KEY')},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ))
      ..interceptors.add(PrettyDioLogger());
  }

  static Dio getChatDio() {
    return Dio(BaseOptions(
      baseUrl: 'https://immortal-basically-lemur.ngrok-free.app/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    ))
      ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ));
  }

  static Dio getAgrovisionDio() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await CacheHelper.getString(key: 'token');
        if (token.isEmpty) {
          _redirectToLogin();
          return handler.reject(DioException(requestOptions: options));
        }
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) _redirectToLogin();
        return handler.next(error);
      },
    ));

    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      responseHeader: true,
      error: true,
      compact: false,
    ));

    return dio;
  }

  static void _redirectToLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppRouter.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    });
  }
}
