import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import '../Logic/app_cubit.dart';
import '../../disease_detection/Ui/disease_detection_screen.dart';
import '../../home/Ui/home_screen.dart';
import '../../home/Ui/settings_screen.dart';
import '../../monitoring/UI/monitoring_screen.dart';
import '../Logic/app_state.dart';

class ScreenLayout extends StatelessWidget {
  const ScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppCubit(), // Provide the AppCubit to the widget tree
      child: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          final appCubit =
              AppCubit.get(context); // Get the current AppCubit instance

          // Define icons for bottom navigation
          final iconList = <IconData>[
            Icons.home,
            Icons.monitor_heart,
            Icons.analytics,
            Icons.settings,
          ];

          // Screens to navigate between
          final List<Widget> screens = [
            const HomeScreen(),
            const MonitoringScreen(),
            const DiseaseDetectionScreen(),
            const SettingsScreen(),
          ];

          return Scaffold(
            body: screens[appCubit.bottomNavIndex],

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (kDebugMode) {
                  print("Floating Action Button Pressed!");
                }
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,

            // Animated Bottom Navigation Bar
            bottomNavigationBar: AnimatedBottomNavigationBar(
              icons: iconList,
              activeIndex: appCubit
                  .bottomNavIndex, // Use the current index from the cubit
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.smoothEdge,
              onTap: (index) => appCubit
                  .changeBottomNavIndex(index), // Change index using cubit
              backgroundColor: Theme.of(context).canvasColor,
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: Colors.grey,
              leftCornerRadius: 32,
              rightCornerRadius: 32,
            ),
          );
        },
      ),
    );
  }
}
