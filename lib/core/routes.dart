import 'package:flutter/material.dart';
import '../view/screens/disease_detection/disease_detection_screen.dart';
import '../view/screens/splash/splash_screen.dart';
import '../view/screens/onboarding/onboarding_screen.dart';
import '../view/screens/home/home_screen.dart';
import '../view/screens/monitoring/monitoring_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  OnboardingScreen.routeName: (context) => const OnboardingScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  MonitoringScreen.routeName: (context) => const MonitoringScreen(),
  DiseaseDetectionScreen.routeName: (context) => const DiseaseDetectionScreen(),
};
