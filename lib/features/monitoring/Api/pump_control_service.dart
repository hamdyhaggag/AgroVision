import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PumpControlService {
  final Dio dio;

  PumpControlService()
      : dio = Dio(
          BaseOptions(
            baseUrl: dotenv.env['DISEASE_DETECTION_BASE_URL'] ??
                'https://positive-tiger-endlessly.ngrok-free.app/',
          ),
        ) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );
  }

  Future<void> manualOn() async {
    try {
      await dio.get('manual/on');
    } catch (e) {
      throw Exception('Failed to turn manual on: $e');
    }
  }

  Future<void> manualOff() async {
    try {
      await dio.get('manual/off');
    } catch (e) {
      throw Exception('Failed to turn manual off: $e');
    }
  }

  Future<void> autoOn() async {
    try {
      await dio.get('auto');
    } catch (e) {
      throw Exception('Failed to turn auto on: $e');
    }
  }

  Future<void> autoOff() async {
    try {
      await dio.get('stop_auto');
    } catch (e) {
      throw Exception('Failed to turn auto off: $e');
    }
  }
}
