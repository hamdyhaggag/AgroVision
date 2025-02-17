import 'package:flutter/material.dart';
import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/models/weather_model.dart';

class WeatherWidget extends StatelessWidget {
  final WeatherModel weather;

  const WeatherWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white),
                const SizedBox(width: 8),
                Text('${weather.name}, ${weather.sys.country}',
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('${weather.main.temp.round()}°C',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                Image.asset(
                  _getWeatherIcon(weather.weather.first.main),
                  width: 60,
                  height: 60,
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildMetric('Humidity', '${weather.main.humidity}%'),
                _buildMetric('Wind', '${weather.wind.speed} m/s'),
                _buildMetric('Pressure', '${weather.main.pressure} hPa'),
                _buildMetric(
                    'Visibility', '${(weather.visibility / 1000).round()} km'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  String _getWeatherIcon(String condition) {
    const base = 'assets/weather/';
    switch (condition.toLowerCase()) {
      case 'clouds':
        return '${base}cloudy.png';
      case 'rain':
        return '${base}rain.png';
      case 'clear':
        return '${base}sunny.png';
      default:
        return '${base}cloudy.png';
    }
  }
}
