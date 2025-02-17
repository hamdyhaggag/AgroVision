// weather_model.dart
class WeatherModel {
  final String name;
  final Sys sys;
  final Main main;
  final Wind wind;
  final int visibility;
  final List<Weather> weather;

  WeatherModel({
    required this.name,
    required this.sys,
    required this.main,
    required this.wind,
    required this.visibility,
    required this.weather,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      name: json['name'],
      sys: Sys.fromJson(json['sys']),
      main: Main.fromJson(json['main']),
      wind: Wind.fromJson(json['wind']),
      visibility: json['visibility'],
      weather:
          (json['weather'] as List).map((e) => Weather.fromJson(e)).toList(),
    );
  }
}

class Sys {
  final String country;

  Sys({required this.country});

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(country: json['country']);
  }
}

class Main {
  final double temp;
  final int humidity;
  final int pressure;

  Main({
    required this.temp,
    required this.humidity,
    required this.pressure,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'].toDouble(),
      humidity: json['humidity'],
      pressure: json['pressure'],
    );
  }
}

class Wind {
  final double speed;

  Wind({required this.speed});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(speed: json['speed'].toDouble());
  }
}

class Weather {
  final String main;

  Weather({required this.main});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(main: json['main']);
  }
}
