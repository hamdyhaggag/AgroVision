import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DiseaseDetectionService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['DISEASE_DETECTION_BASE_URL'] ??
          'https://positive-tiger-endlessly.ngrok-free.app',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<Map<String, dynamic>> predictDisease(
      String filePath, String plantType) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: 'image.jpg'),
        'plant': plantType,
      });

      Response response = await _dio.post('/predict', data: formData);

      return response.data;
    } catch (e) {
      throw Exception('Error detecting disease: $e');
    }
  }
}
