class SensorDataState {
  final bool loading;
  final Map<String, String> data;
  final String? error;

  SensorDataState({required this.loading, required this.data, this.error});

  factory SensorDataState.loading() => SensorDataState(loading: true, data: {});
  factory SensorDataState.success(Map<String, String> data) =>
      SensorDataState(loading: false, data: data);
  factory SensorDataState.error(String error) =>
      SensorDataState(loading: false, data: {}, error: error);
}
