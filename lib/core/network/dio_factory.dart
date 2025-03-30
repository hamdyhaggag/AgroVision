import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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
      baseUrl: 'https://ab2f-41-238-179-181.ngrok-free.app/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ))
      ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ));
  }
}
