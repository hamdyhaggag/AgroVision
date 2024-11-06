import 'package:flutter/material.dart';
import 'core/themes.dart'; // Global theme configurations
import 'core/routes.dart'; // Route definitions
import 'view/screens/splash/splash_screen.dart'; // Initial screen (Splash)

class AgroVision extends StatelessWidget {
  const AgroVision({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Agriculture Monitoring', // App title
      theme: AppTheme.lightTheme, // Applying global light theme
      darkTheme: AppTheme.darkTheme, // Optional: Dark theme
      themeMode: ThemeMode.system, // Light/Dark mode based on system preference
      initialRoute:
          SplashScreen.routeName, // Setting the initial route to SplashScreen
      routes: appRoutes, // Setting named routes from routes.dart
      debugShowCheckedModeBanner:
          false, // Remove the debug banner in top-right corner
    );
  }
}
