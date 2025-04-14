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
  bool _showSuccess = false;
  String _successMessage = '';

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
        _successMessage = 'Profile picture updated successfully! 🌟';
        _showSuccess = true;
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showSuccess = false);
        }
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
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
                            width: 2.0,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 56,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : const AssetImage('assets/images/user.png')
                                      as ImageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor
                                      .withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                padding: const EdgeInsets.all(6.0),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(60),
                                  onTap: _pickImage,
                                  child: const SizedBox(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    FutureBuilder<String>(
                      future: _userNameFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        final userName = snapshot.data ?? '';
                        if (kDebugMode) {
                          print('🟣 Displaying Username: $userName');
                        }
                        return Text(
                          userName.isNotEmpty ? userName : 'User',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
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
          Positioned(
            top: 200,
            left: MediaQuery.of(context).size.width * 0.33 - 100,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _showSuccess ? 1.0 : 0.0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      _successMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
