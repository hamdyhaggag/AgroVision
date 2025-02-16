import 'package:meta/meta.dart';

import '../../../models/weather_model.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

@immutable
class HomeLoading extends HomeState {}

@immutable
class HomeLoaded extends HomeState {
  final WeatherModel weather;
  HomeLoaded({required this.weather});
}

@immutable
class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}
