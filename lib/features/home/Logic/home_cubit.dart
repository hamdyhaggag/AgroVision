import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agro_vision/core/helpers/location_helper.dart';
import 'package:agro_vision/core/network/weather_service.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final WeatherService weatherService;
  final LocationHelper locationHelper;

  HomeCubit({
    required this.weatherService,
    required this.locationHelper,
  }) : super(HomeInitial());

  Future<void> getWeatherData() async {
    emit(HomeLoading());
    try {
      final position = await locationHelper.getCurrentLocation();
      final weather = await weatherService.getWeather(
        position.latitude,
        position.longitude,
      );
      emit(HomeLoaded(weather: weather));
    } catch (e) {
      emit(HomeError(message: 'Failed to load weather: ${e.toString()}'));
    }
  }
}
