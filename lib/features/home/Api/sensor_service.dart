import 'package:dio/dio.dart';
import '../../../models/sensor_data_model.dart' as sensor_data;

class SensorService {
  final Dio dio;

  SensorService(this.dio);

  Future<sensor_data.Sensor> getSensorStatus() async {
    try {
      final response = await dio.get(
        'https://immortal-basically-lemur.ngrok-free.app/latest-sensor-status',
      );
      return sensor_data.Sensor.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch sensor data: $e');
    }
  }
}
