import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agro_vision/core/helpers/location_helper.dart';
import 'package:agro_vision/core/network/weather_service.dart';
import 'package:agro_vision/core/helpers/cache_helper.dart';
import '../../../../models/sensor_data_model.dart' as sensor_data;
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
      try {
        final sensor = await sensorService.getSensorStatus();
        // Save the sensor data to cache with timestamp
        await CacheHelper.saveSensorData([sensor]);
        emit(HomeLoaded(
          weather: weather,
          sensors: [sensor],
        ));
      } catch (e) {
        // If sensor data fails, try to load from cache
        final cachedSensors = CacheHelper.getSensorData();
        if (cachedSensors.isNotEmpty && !CacheHelper.isSensorDataStale()) {
          emit(HomeLoaded(
            weather: weather,
            sensors: cachedSensors,
            sensorError:
                'Using cached sensor data from ${CacheHelper.getLastSensorDataUpdate()?.toString() ?? "unknown time"}: ${e.toString()}',
          ));
        } else {
          // Clear stale cache if it exists
          await CacheHelper.clearStaleSensorData();
          emit(HomeLoaded(
            weather: weather,
            sensors: [],
            sensorError: 'Failed to load sensor data: ${e.toString()}',
          ));
        }
      }
    } catch (e) {
      emit(HomeError(message: 'Failed to load data: ${e.toString()}'));
    }
  }

  void updateSensors(List<sensor_data.Sensor> sensors) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        sensors: sensors,
        sensorError: null,
      ));
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
        sensors: [sensor_data.Sensor.fromJson(data)],
        sensorError: null,
      ));
    }
  }
}
