import 'package:agro_vision/features/authentication/UI/congratulation_screen.dart';
import 'package:flutter/material.dart';
import '../../features/authentication/UI/create_password_screen.dart';
import '../../features/authentication/UI/forgot password/forgot_password_email.dart';
import '../../features/authentication/UI/forgot password/forgot_password_phone.dart';
import '../../features/authentication/UI/otp/otp_email_screen.dart';
import '../../features/authentication/UI/otp/otp_phone_screen.dart';
import '../../features/home/Ui/screen_layout.dart';
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
      case AppRoutes.screenLayout:
        return MaterialPageRoute(
          builder: (_) => const ScreenLayout(),
        );
      case AppRoutes.forgotPasswordPhone:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordPhone(),
        );
      case AppRoutes.otpPhoneScreen:
        return MaterialPageRoute(
          builder: (_) => const OtpPhoneScreen(),
        );
      case AppRoutes.forgotPasswordEmail:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordEmail(),
        );
      case AppRoutes.otpEmailScreen:
        return MaterialPageRoute(
          builder: (_) => const OtpEmailScreen(email: 'user@example.com'),
        );
      case AppRoutes.createNewPassword:
        return MaterialPageRoute(
          builder: (_) => CreateNewPassword(),
        );
      case AppRoutes.congratulationsScreen:
        return MaterialPageRoute(
          builder: (_) => const CongratulationsScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
    }
  }
}
