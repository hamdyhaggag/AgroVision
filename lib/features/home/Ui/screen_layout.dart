import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import '../../splash/Logic/app_cubit.dart';
import '../../disease_detection/Ui/disease_detection_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import '../../monitoring/UI/monitoring_screen.dart';
import '../../splash/Logic/app_state.dart';

class ScreenLayout extends StatelessWidget {
  const ScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppCubit(),
      child: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          final appCubit = AppCubit.get(context);

          final iconList = <IconData>[
            Icons.home,
            Icons.monitor_heart,
            Icons.analytics,
            Icons.settings,
          ];

          final List<Widget> screens = [
            const HomeScreen(),
            const MonitoringScreen(),
            DiseaseDetectionScreen(),
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
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Image.asset(
                'assets/images/camera.png',
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBottomNavigationBar(
              icons: iconList,
              activeIndex: appCubit.bottomNavIndex,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.smoothEdge,
              onTap: (index) => appCubit.changeBottomNavIndex(index),
              backgroundColor: AppColors.navBarColor,
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: AppColors.greyColor,
              leftCornerRadius: 0,
              rightCornerRadius: 0,
            ),
          );
        },
      ),
    );
  }
}
