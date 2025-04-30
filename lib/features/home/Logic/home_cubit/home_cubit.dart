import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agro_vision/core/helpers/location_helper.dart';
import 'package:agro_vision/core/network/weather_service.dart';

import '../../../../models/sensor_data_model.dart';
import '../../Api/sensor_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final WeatherService weatherService;
  final LocationHelper locationHelper;
  final SensorService sensorService;

  HomeCubit({
    required this.weatherService,
    required this.locationHelper,
    required this.sensorService,
  }) : super(HomeInitial());

  Future<void> getWeatherData() async {
    emit(HomeLoading());
    try {
      final position = await locationHelper.getCurrentLocation();
      final weather = await weatherService.getWeather(
        position.latitude,
        position.longitude,
      );
      final sensor = await sensorService.getSensorStatus();
      emit(HomeLoaded(
        weather: weather,
        sensors: [sensor],
      ));
    } catch (e) {
      emit(HomeError(message: 'Failed to load data: ${e.toString()}'));
    }
  }

  void handleSensorError(dynamic error) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        sensorError: error.toString(),
        sensors: [],
      ));
    }
  }

  void updateSensorData(Map<String, dynamic> data) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        sensors: [Sensor.fromJson(data)],
        sensorError: null,
      ));
    }
  }
}
