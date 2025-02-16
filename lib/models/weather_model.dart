import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel {
  final String name;
  final Main main;
  final List<Weather> weather;
  final Wind wind;
  final int visibility;
  final Sys sys;

  WeatherModel({
    required this.name,
    required this.main,
    required this.weather,
    required this.wind,
    required this.visibility,
    required this.sys,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);
}

@JsonSerializable()
class Main {
  final double temp;
  final int humidity;
  final int pressure;

  Main({required this.temp, required this.humidity, required this.pressure});

  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);
}

@JsonSerializable()
class Weather {
  final String icon;

  Weather({required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}

@JsonSerializable()
class Wind {
  final double speed;

  Wind({required this.speed});

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
}

@JsonSerializable()
class Sys {
  final String country;

  Sys({required this.country});

  factory Sys.fromJson(Map<String, dynamic> json) => _$SysFromJson(json);
}
