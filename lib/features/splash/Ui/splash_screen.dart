import 'dart:async';
import 'package:agro_vision/features/home/Ui/screen_layout.dart';
import 'package:flutter/material.dart';
import 'package:agro_vision/features/authentication/UI/login_screen.dart';
import '../../../core/helpers/shared_pref_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInCubic,
    );

    _animationController.forward();

    Timer(const Duration(seconds: 3), () {
      // Check the login state from SharedPreferences
      bool isLoggedIn = CacheHelper.getBoolean(key: 'isLoggedIn');

      if (isLoggedIn) {
        // If logged in, navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ScreenLayout()),
        );
      } else {
        // If not logged in, navigate to LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.09,
            image: AssetImage('assets/images/App_Logo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _animation.value,
                    child: child,
                  );
                },
                child: Transform.translate(
                  offset: const Offset(-20.0, 0.0),
                  child: const Image(
                    image: AssetImage('assets/images/App_Logo.png'),
                    height: 240.0,
                    width: 270.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
