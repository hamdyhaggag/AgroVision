// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
      name: json['name'] as String,
      main: Main.fromJson(json['main'] as Map<String, dynamic>),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as Map<String, dynamic>))
          .toList(),
      wind: Wind.fromJson(json['wind'] as Map<String, dynamic>),
      visibility: (json['visibility'] as num).toInt(),
      sys: Sys.fromJson(json['sys'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'main': instance.main,
      'weather': instance.weather,
      'wind': instance.wind,
      'visibility': instance.visibility,
      'sys': instance.sys,
    };

Main _$MainFromJson(Map<String, dynamic> json) => Main(
      temp: (json['temp'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      pressure: (json['pressure'] as num).toInt(),
    );

Map<String, dynamic> _$MainToJson(Main instance) => <String, dynamic>{
      'temp': instance.temp,
      'humidity': instance.humidity,
      'pressure': instance.pressure,
    };

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'icon': instance.icon,
    };

Wind _$WindFromJson(Map<String, dynamic> json) => Wind(
      speed: (json['speed'] as num).toDouble(),
    );

Map<String, dynamic> _$WindToJson(Wind instance) => <String, dynamic>{
      'speed': instance.speed,
    };

Sys _$SysFromJson(Map<String, dynamic> json) => Sys(
      country: json['country'] as String,
    );

Map<String, dynamic> _$SysToJson(Sys instance) => <String, dynamic>{
      'country': instance.country,
    };
