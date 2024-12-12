import 'package:bloc/bloc.dart';
import '../Api/sensor_data_service.dart';

abstract class SensorDataState {}

class SensorDataInitial extends SensorDataState {}

class SensorDataLoading extends SensorDataState {}

class SensorDataLoaded extends SensorDataState {
  final Map<String, dynamic> data;

  SensorDataLoaded(this.data);
}

class SensorDataError extends SensorDataState {
  final String error;

  SensorDataError(this.error);
}

class SensorDataCubit extends Cubit<SensorDataState> {
  final SensorDataService _sensorDataService;

  SensorDataCubit(this._sensorDataService) : super(SensorDataInitial());

  Future<void> loadSensorData() async {
    emit(SensorDataLoading());
    try {
      final data = await _sensorDataService.fetchSensorData();
      emit(SensorDataLoaded(data));
    } catch (e) {
      emit(SensorDataError(e.toString()));
    }
  }
}
