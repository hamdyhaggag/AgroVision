import 'package:flutter/material.dart';
import '../../features/onboarding/Ui/onboarding_screen.dart';
import '../../features/splash/Ui/splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static BuildContext? currentContext = navigatorKey.currentContext;
  Route generateRoute(RouteSettings settings) {
    // final arguments = settings.arguments;
    switch (settings.name) {
      case AppRoutes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
    }
  }
}
