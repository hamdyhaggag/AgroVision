import 'dart:io';

import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/cache_helper.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/themes/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  File? _profileImage;
  late Future<String> _userNameFuture;

  @override
  void initState() {
    super.initState();
    _userNameFuture = _getUserName();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    await CacheHelper.ensureInitialized();
    final imagePath = CacheHelper.getString(key: 'profileImage');
    if (imagePath.isNotEmpty && File(imagePath).existsSync()) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await CacheHelper.saveData(key: 'profileImage', value: imageFile.path);

      setState(() {
        _profileImage = imageFile;
      });
    }
  }

  Future<String> _getUserName() async {
    await CacheHelper.ensureInitialized();
    return CacheHelper.getString(key: 'userName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 4.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 56,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/images/user.png')
                              as ImageProvider,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                FutureBuilder<String>(
                  future: _userNameFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    final userName = snapshot.data ?? '';
                    if (kDebugMode) {
                      print('🟣 Displaying Username: $userName');
                    }

                    return Text(
                      userName.isNotEmpty ? userName : 'User',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SYNE',
                          ),
                    );
                  },
                ),
                const SizedBox(height: 4.0),
                Text(
                  '@Agro Vision',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text(
                'Account Preferences',
                style: TextStyle(fontFamily: 'SYNE'),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            SwitchListTile(
              activeColor: AppColors.primaryColor,
              value: true,
              onChanged: (bool value) {},
              title: const Text(
                'App Notifications',
                style: TextStyle(fontFamily: 'SYNE'),
              ),
              secondary: const Icon(Icons.notifications_outlined),
            ),
            SwitchListTile(
              activeColor: AppColors.primaryColor,
              value: false,
              onChanged: (bool value) {},
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontFamily: 'SYNE'),
              ),
              secondary: const Icon(Icons.dark_mode_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: const Text(
                'Rate Us',
                style: TextStyle(fontFamily: 'SYNE'),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.feedback_outlined),
              title: const Text(
                'Provide Feedback',
                style: TextStyle(fontFamily: 'SYNE'),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Log Out',
                style: TextStyle(color: Colors.red, fontFamily: 'SYNE'),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.red),
              onTap: () => Navigator.pushNamed(context, AppRoutes.logout),
            ),
          ],
        ),
      ),
    );
  }
}
