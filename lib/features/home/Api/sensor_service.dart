import 'package:dio/dio.dart';

import '../../../models/sensor_data_model.dart';

class SensorService {
  final Dio dio;

  SensorService(this.dio);

  Future<Sensor> getSensorStatus() async {
    try {
      final response = await dio.get(
        'https://immortal-basically-lemur.ngrok-free.app/latest-sensor-status',
      );
      return Sensor.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch sensor data: $e');
    }
  }
}
