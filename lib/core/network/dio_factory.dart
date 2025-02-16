import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  /// Private constructor
  DioFactory._();

  static Dio? _dio;

  static Dio getDio() {
    if (_dio == null) {
      _initializeDio();
    }
    return _dio!;
  }

  static void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.openweathermap.org/data/2.5',
      queryParameters: {
        'appid': dotenv.get('OPENWEATHER_API_KEY'),
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    _addInterceptors();
  }

  static void _addInterceptors() {
    _dio?.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    ]);
  }
}
