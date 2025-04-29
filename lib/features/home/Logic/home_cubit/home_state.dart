import 'package:meta/meta.dart';

import '../../../../models/sensor_data_model.dart';
import '../../../../models/weather_model.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

@immutable
class HomeLoading extends HomeState {}

@immutable
class HomeLoaded extends HomeState {
  final WeatherModel weather;
  final List<Sensor> sensors;

  HomeLoaded({required this.weather, required this.sensors});
}

@immutable
class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}
