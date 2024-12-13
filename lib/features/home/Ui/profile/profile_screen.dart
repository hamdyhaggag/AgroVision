import 'package:flutter/material.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/themes/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryColor, Colors.green.shade200],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/images/user.png'),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Ahmed Ali',
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'SYNE',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text('@AgroVision',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'SYNE',
                            color: Colors.white.withOpacity(0.7))),
                    const SizedBox(height: 5),
                    const Text('Dedicated Farmer | Agriculture Advocate',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'SYNE',
                        )),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AppRoutes.editProfileScreen);
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text('Edit Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SYNE',
                          )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade500,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 30),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 4))
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('50',
                            style: TextStyle(
                                fontFamily: 'SYNE',
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        Text('Followers',
                            style: TextStyle(
                                fontFamily: 'SYNE',
                                fontSize: 14,
                                color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('120',
                            style: TextStyle(
                                fontFamily: 'SYNE',
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        Text('Following',
                            style: TextStyle(
                                fontFamily: 'SYNE',
                                fontSize: 14,
                                color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('25',
                            style: TextStyle(
                                fontFamily: 'SYNE',
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        Text('Posts',
                            style: TextStyle(
                                fontFamily: 'SYNE',
                                fontSize: 14,
                                color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading:
                    const Icon(Icons.settings, color: AppColors.primaryColor),
                title: const Text(
                  'Account Settings',
                  style: TextStyle(fontFamily: 'SYNE'),
                ),
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.settingsScreen),
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontFamily: 'SYNE'),
                ),
                onTap: () => Navigator.pushNamed(context, AppRoutes.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
