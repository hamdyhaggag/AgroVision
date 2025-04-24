import 'package:flutter/material.dart';

class SensorColors {
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.orange;
  static const Color errorColor = Colors.red;
  static const Color primaryColor = Colors.blue;
}

Map<String, Map<String, double>> optimalRanges = {
  'EC': {'max': 1.0}, // Optimal <= 1, error > 4
  'Humidity': {'min': 35.0, 'max': 75.0},
  'PH': {'min': 6.0, 'max': 7.5},
  'Temp': {'min': 18.0, 'max': 30.0},
  'N': {'min': 10.0},
  'P': {'min': 12.0},
  'K': {'min': 120.0, 'max': 170.0},
  'Fertility': {'min': 3.0, 'max': 6.0},
};

bool isSensorInError(String sensor, double value) {
  final range = optimalRanges[sensor];
  if (range == null) return false;
  if (sensor == 'EC') {
    return value > 4.0; // Error if > 4
  } else if (range.containsKey('min') && range.containsKey('max')) {
    return value < range['min']! || value > range['max']!;
  } else if (range.containsKey('min')) {
    return value < range['min']!;
  } else if (range.containsKey('max')) {
    return value > range['max']!;
  }
  return false;
}
