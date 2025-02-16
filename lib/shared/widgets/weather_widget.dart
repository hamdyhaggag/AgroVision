import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../../models/weather_model.dart';

class WeatherWidget extends StatelessWidget {
  final WeatherModel weather;

  const WeatherWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryColor,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.location_on, color: Colors.white),
              const SizedBox(width: 5),
              Text('${weather.name}, ${weather.sys.country}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'SYNE',
                      fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Text('${weather.main.temp.round()}°C',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SYNE')),
              const Spacer(),
              Image.asset(
                _getTempIcon(
                    weather.main.temp), // Corrected to use local 'weather'
                height: 50,
                width: 50,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.thermostat, color: Colors.white),
              )
            ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  const Text('Humidity',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SYNE',
                          fontWeight: FontWeight.bold)),
                  Text('${weather.main.humidity}%',
                      style: const TextStyle(
                          color: Colors.white, fontFamily: 'SYNE')),
                ]),
                Column(children: [
                  const Text('Wind',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SYNE',
                          fontWeight: FontWeight.bold)),
                  Text('${weather.wind.speed}m/s',
                      style: const TextStyle(
                          color: Colors.white, fontFamily: 'SYNE')),
                ]),
                Column(children: [
                  const Text('Pressure',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SYNE',
                          fontWeight: FontWeight.bold)),
                  Text('${weather.main.pressure}hPa',
                      style: const TextStyle(
                          color: Colors.white, fontFamily: 'SYNE')),
                ]),
                Column(children: [
                  const Text('Visibility',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SYNE',
                          fontWeight: FontWeight.bold)),
                  Text('${(weather.visibility / 1000).round()}km',
                      style: const TextStyle(
                          color: Colors.white, fontFamily: 'SYNE')),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTempIcon(double temp) {
    const basePath = 'assets/icon/weather_icons/';

    if (temp >= 35) return '${basePath}clear_sky.png'; // Extreme heat
    if (temp >= 30) return '${basePath}few_clouds.png'; // Hot
    if (temp >= 25) return '${basePath}scattered_clouds.png'; // Warm
    if (temp >= 20) return '${basePath}broken_clouds.png'; // Mild
    if (temp >= 15) return '${basePath}shower_rain.png'; // Cool
    if (temp >= 10) return '${basePath}rain.png'; // Chilly
    if (temp >= 5) return '${basePath}thunderstorm.png'; // Cold
    if (temp >= 0) return '${basePath}snow.png'; // Freezing
    return '${basePath}mist.png'; // Sub-zero
  }
}
