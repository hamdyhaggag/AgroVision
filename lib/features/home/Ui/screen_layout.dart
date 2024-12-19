import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import '../../chat/Ui/chat_list_screen.dart';
import '../../disease_detection/Ui/plant_details_screen.dart';
import '../../monitoring/UI/history_screen.dart';
import '../../splash/Logic/app_cubit.dart';
import '../../disease_detection/Ui/disease_detection_screen.dart';
import 'home_screen.dart';
import '../../splash/Logic/app_state.dart';

class ScreenLayout extends StatelessWidget {
  ScreenLayout({super.key});
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppCubit(),
      child: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          final appCubit = AppCubit.get(context);

          final List<Widget> screens = [
            const HomeScreen(),
            const HistoryScreen(),
            DiseaseDetectionScreen(),
            ChatListScreen(),
          ];

          return Scaffold(
            body: screens[appCubit.bottomNavIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    String? selectedPlant;

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (selectedPlant == null) ...[
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors
                                        .red[100], // Adjust color as needed
                                    radius: 20, // Adjust size as needed
                                    child: Image.asset(
                                      'assets/images/tomato.png', // Replace with your image asset path
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: const Text(
                                    'Tomato',
                                    style: TextStyle(
                                        fontFamily: 'SYNE', fontSize: 15),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedPlant = 'Tomato';
                                    });
                                  },
                                ),
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors
                                        .brown[100], // Adjust color as needed
                                    radius: 20, // Adjust size as needed
                                    child: Image.asset(
                                      'assets/images/potato.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: const Text(
                                    'Potato',
                                    style: TextStyle(
                                        fontFamily: 'SYNE', fontSize: 15),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedPlant = 'Potato';
                                    });
                                  },
                                ),
                              ] else ...[
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text(
                                    'Pick from Gallery',
                                    style: TextStyle(
                                        fontFamily: 'SYNE', fontSize: 15),
                                  ),
                                  onTap: () async {
                                    final XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 85,
                                    );
                                    if (image != null) {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PlantDetailsScreen(
                                            imagePath: image.path,
                                            selectedPlant: selectedPlant,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text(
                                    'Take a Photo',
                                    style: TextStyle(
                                        fontFamily: 'SYNE', fontSize: 15),
                                  ),
                                  onTap: () async {
                                    final XFile? image = await picker.pickImage(
                                      source: ImageSource.camera,
                                      imageQuality: 85,
                                    );
                                    if (image != null) {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PlantDetailsScreen(
                                            imagePath: image.path,
                                            selectedPlant: selectedPlant,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              backgroundColor: AppColors.navBarColor,
              elevation: 0,
              child: Image.asset(
                'assets/images/camera.png',
                width: 45,
                height: 45,
                fit: BoxFit.contain,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: SlidingClippedNavBar(
              backgroundColor: AppColors.navBarColor,
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: AppColors.greyColor,
              barItems: [
                BarItem(
                  icon: Icons.home,
                  title: 'Home',
                ),
                BarItem(
                  icon: Icons.monitor_heart,
                  title: 'Statistics',
                ),
                BarItem(
                  icon: Icons.analytics,
                  title: 'Detection',
                ),
                BarItem(
                  icon: Icons.chat,
                  title: 'Chat',
                ),
              ],
              selectedIndex: appCubit.bottomNavIndex,
              onButtonPressed: (index) => appCubit.changeBottomNavIndex(index),
            ),
          );
        },
      ),
    );
  }
}
