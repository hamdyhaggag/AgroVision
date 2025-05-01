import 'package:meta/meta.dart';
import '../../../../models/sensor_data_model.dart' as sensor_data;
import '../../../../models/weather_model.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

@immutable
class HomeLoading extends HomeState {}

@immutable
class HomeLoaded extends HomeState {
  final WeatherModel weather;
  final List<sensor_data.Sensor> sensors;
  final String? sensorError;

  HomeLoaded({
    required this.weather,
    required this.sensors,
    this.sensorError,
  });

  HomeLoaded copyWith({
    WeatherModel? weather,
    List<sensor_data.Sensor>? sensors,
    String? sensorError,
  }) {
    return HomeLoaded(
      weather: weather ?? this.weather,
      sensors: sensors ?? this.sensors,
      sensorError: sensorError ?? this.sensorError,
    );
  }
}

@immutable
class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}
