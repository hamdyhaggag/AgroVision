import 'dart:io';
import 'package:agro_vision/core/helpers/cache_helper.dart';
import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/routing/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  File? _profileImage;
  String username = 'User';
  bool _notificationsEnabled = true;
  late AnimationController _controller;
  late Animation<double> _avatarAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _avatarAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    CacheHelper.profileImageNotifier.addListener(_updateProfileImage);
  }

  @override
  void dispose() {
    _controller.dispose();
    CacheHelper.profileImageNotifier.removeListener(_updateProfileImage);
    super.dispose();
  }

  Future<void> _loadUserData() async {
    await CacheHelper.ensureInitialized();
    String? fetchedUsername = CacheHelper.getString(key: 'userName');
    setState(() {
      username = fetchedUsername;
    });
    _updateProfileImage();
  }

  void _showComingSoonMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildCustomSnackBar(message),
    );
  }

  void _updateProfileImage() {
    String imagePath = CacheHelper.profileImageNotifier.value.isNotEmpty
        ? CacheHelper.profileImageNotifier.value
        : CacheHelper.getString(key: 'profileImage');
    if (imagePath.isNotEmpty && File(imagePath).existsSync()) {
      setState(() {
        _profileImage = File(imagePath);
      });
    } else {
      setState(() {
        _profileImage = null;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      String imagePath = pickedFile.path;
      await CacheHelper.saveData(key: 'profileImage', value: imagePath);
      CacheHelper.profileImageNotifier.value = imagePath;
      setState(() {
        _profileImage = File(imagePath);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        _buildCustomSnackBar('Profile updated! ✨'),
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: AppColors.primaryColor),
                    SizedBox(width: 8),
                    Text('Camera',
                        style: TextStyle(color: AppColors.primaryColor)),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo, color: AppColors.primaryColor),
                    SizedBox(width: 8),
                    Text('Gallery',
                        style: TextStyle(color: AppColors.primaryColor)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SnackBar _buildCustomSnackBar(String message, {bool isError = false}) {
    return SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error : Icons.check_circle,
            color: AppColors.surface,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.surface),
            ),
          ),
        ],
      ),
      backgroundColor: isError ? AppColors.error : AppColors.primaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.whiteColor, Colors.white],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildProfileHeader(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            SliverToBoxAdapter(child: _buildSettingsContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.primaryColorshade],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) => _controller.reverse(),
            onTapCancel: () => _controller.reverse(),
            onTap: _showImagePickerOptions,
            child: ScaleTransition(
              scale: _avatarAnimation,
              child: ElasticIn(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage('assets/images/user.png')
                                as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit,
                            color: AppColors.primaryColor, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            username,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            'Visionary Farmer',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Personalization'),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              value: false,
              onChanged: (_) => _showComingSoonMessage(
                  'Dark mode is coming soon! Stay tuned.'),
            ),
            _buildSwitchTile(
              icon: Icons.notifications,
              title: 'Notifications',
              value: _notificationsEnabled,
              onChanged: (value) =>
                  setState(() => _notificationsEnabled = value),
            ),
          ]),
          const SizedBox(height: 20),
          _buildSectionTitle('Support'),
          _buildSettingsCard([
            _buildActionTile(
              icon: Icons.star,
              title: 'Rate Us',
              onTap: () => _showComingSoonMessage('Rate us is coming soon! '),
              color: Colors.amber,
            ),
            _buildActionTile(
              icon: Icons.feedback,
              title: 'Feedback',
              onTap: () => _showComingSoonMessage('Feedback is coming soon! '),
              color: Colors.blue,
            ),
          ]),
          const SizedBox(height: 20),
          _buildSectionTitle('Account'),
          _buildSettingsCard([
            _buildActionTile(
              icon: Icons.logout,
              title: 'Log Out',
              onTap: () => Navigator.pushNamed(context, AppRoutes.logout),
              color: Colors.red,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return FadeInLeft(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Text(title, style: const TextStyle(color: AppColors.onSurface)),
            const SizedBox(width: 8),
            const Expanded(
              child: Divider(
                color: AppColors.divider,
                thickness: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryColor,
        child: Icon(icon, color: AppColors.surface),
      ),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.onSurface),
      ),
      trailing: Switch(
        activeColor: AppColors.primaryColor,
        inactiveThumbColor: AppColors.divider,
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.onSurface),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.divider,
      ),
      onTap: onTap,
    );
  }
}
