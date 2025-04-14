import 'package:dio/dio.dart';

class SensorDataService {
  final Dio dio;

  SensorDataService(this.dio);

  Future<Map<String, dynamic>> fetchSensorData() async {
    try {
      final response = await dio
          .get('https://final.agrovision.ltd/api/firebase/last-record');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to fetch sensor data: ${response.data['message']}');
      }
    } catch (e) {
      throw Exception('Failed to fetch sensor data: $e');
    }
  }
}
