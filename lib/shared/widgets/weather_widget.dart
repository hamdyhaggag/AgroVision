import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  final String location;
  final String temperature;
  final String weatherIcon;
  final Map<String, String> additionalInfo;

  const WeatherWidget({
    super.key,
    required this.location,
    required this.temperature,
    required this.weatherIcon,
    required this.additionalInfo,
  });

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
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Text(
                  location,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  temperature,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Image.asset(weatherIcon, height: 50),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: additionalInfo.entries.map((entry) {
                return Column(
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      entry.value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
