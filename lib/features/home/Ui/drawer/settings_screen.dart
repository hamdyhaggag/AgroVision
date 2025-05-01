import 'dart:io';
import 'package:agro_vision/core/helpers/cache_helper.dart';
import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/routing/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService(DioFactory.getAgrovisionDio());
  File? _profileImage;
  String username = 'User';
  String? _email;
  String? _phone;
  String? _birthday;
  bool _notificationsEnabled = true;
  late AnimationController _controller;
  late Animation<double> _avatarAnimation;
  final GlobalKey _profileHeaderKey = GlobalKey();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: username);
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
    _nameController.dispose();
    CacheHelper.profileImageNotifier.removeListener(_updateProfileImage);
    super.dispose();
  }

  Future<void> _loadUserData() async {
    await CacheHelper.ensureInitialized();
    setState(() {
      username = CacheHelper.getString(key: 'userName') ?? 'User';
      _email = CacheHelper.getString(key: 'email');
      _phone = CacheHelper.getString(key: 'phone');
      _birthday = CacheHelper.getString(key: 'birthday');
    });
    _updateProfileImage();
  }

  Future<void> _updateProfile() async {
    try {
      final String? validEmail = _email ?? CacheHelper.getString(key: 'email');

      if (validEmail == null || validEmail.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email is required',
                style: TextStyle(color: AppColors.surface)),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final response = await _apiService.updateAccount({
        'name': username,
        'email': validEmail,
        'phone': _phone,
        'birthday': _birthday,
        'img': CacheHelper.getString(key: 'profileImage') ?? 'default.png',
      });

      if (response.data.message.contains('successfully')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data.message),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Profile update failed';
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        errorMessage = errors?.entries.first.value.first ?? errorMessage;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.error,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }

  void _updateProfileImage() {
    String? imagePath = CacheHelper.profileImageNotifier.value.isNotEmpty
        ? CacheHelper.profileImageNotifier.value
        : CacheHelper.getString(key: 'profileImage');

    if (imagePath.isNotEmpty && File(imagePath).existsSync()) {
      setState(() => _profileImage = File(imagePath));
    } else {
      setState(() => _profileImage = null);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      await CacheHelper.saveData(key: 'profileImage', value: pickedFile.path);
      _updateProfile();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
              flexibleSpace:
                  FlexibleSpaceBar(background: _buildProfileHeader()),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
            SliverToBoxAdapter(child: _buildSettingsContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Container(
            key: _profileHeaderKey,
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryColor, AppColors.primaryColorshade],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    width: 110,
                    height: 110,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.8),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : const AssetImage('assets/images/user.png')
                                  as ImageProvider,
                        ),
                        Positioned(
                          bottom: -8,
                          right: -8,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Icon(Icons.edit_rounded,
                                size: 22,
                                color: AppColors.primaryColor.withOpacity(0.8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 70),
                    child: TextFormField(
                      controller: _nameController,
                      onTap: () => _nameController.text = '',
                      onFieldSubmitted: (newName) {
                        if (newName.trim().isNotEmpty && newName != username) {
                          _showNameChangeDialog(username, newName.trim());
                        }
                      },
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      cursorWidth: 2,
                      maxLines: 1,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        enabledBorder: _buildInputBorder(Colors.white54),
                        focusedBorder: _buildInputBorder(Colors.white),
                        hintText: 'Enter Display Name',
                        hintStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.verified_rounded,
                            color: username.isNotEmpty
                                ? AppColors.accentColor
                                : Colors.white54,
                            size: 26,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.workspace_premium_rounded,
                          color: AppColors.accentColor, size: 18),
                      const SizedBox(width: 6),
                      const Text(
                        'Visionary Farmer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputBorder _buildInputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: color,
        width: 1.5,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
      gapPadding: 10,
    );
  }

  Widget _buildSettingsContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Account Details'),
          _buildSettingsCard([
            _buildEditableTile(
              icon: Icons.person,
              title: 'Full Name',
              value: username,
              onEdit: () =>
                  _showNameChangeDialog(username, _nameController.text),
            ),
            _buildInfoTile(
              icon: Icons.email,
              title: 'Email',
              value: _email ?? 'Not available',
            ),
            _buildEditableTile(
              icon: Icons.phone,
              title: 'Phone Number',
              value: _phone ?? 'Not set',
              onEdit: _showPhoneEditDialog,
            ),
            _buildEditableTile(
              icon: Icons.cake,
              title: 'Birthday',
              value: _birthday ?? 'Not set',
              onEdit: _showBirthdayPicker,
            ),
          ]),
          const SizedBox(height: 20),
          _buildSectionTitle('Preferences'),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              value: false,
              onChanged: (_) =>
                  _showComingSoonMessage('Dark mode coming soon!'),
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
              onTap: () => _showComingSoonMessage('Rate us coming soon!'),
              color: Colors.amber,
            ),
            _buildActionTile(
              icon: Icons.feedback,
              title: 'Feedback',
              onTap: () => _showComingSoonMessage('Feedback coming soon!'),
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
              color: AppColors.onSurface.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildEditableTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onEdit,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryColor),
      ),
      title: Text(title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          )),
      subtitle: Text(value,
          style: TextStyle(
            fontSize: 16,
            color: value == 'Not set' ? Colors.grey : AppColors.onSurface,
          )),
      trailing: IconButton(
        icon: Icon(Icons.edit, size: 20, color: AppColors.primaryColor),
        onPressed: onEdit,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryColor),
      ),
      title: Text(title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          )),
      subtitle: Text(value,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.onSurface,
          )),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryColor),
      ),
      title: Text(title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          )),
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
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          )),
      trailing:
          Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.divider),
      onTap: onTap,
    );
  }

  void _showNameChangeDialog(String oldName, String newName) async {
    if (oldName == newName) return;

    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Name Change'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Old Name: $oldName'),
            Text('New Name: $newName'),
            const SizedBox(height: 16),
            const Text('Are you sure you want to change your display name?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => username = newName);
              _updateProfile();
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentColor,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showPhoneEditDialog() {
    final controller = TextEditingController(text: _phone);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Phone Number'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: 'Enter your phone number',
            prefix: Text('+20 '),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => _phone = controller.text.trim());
                CacheHelper.saveData(key: 'phone', value: _phone);
                _updateProfile();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showBirthdayPicker() async {
    final initialDate = _birthday != null
        ? DateTime.parse(_birthday!)
        : DateTime.now().subtract(const Duration(days: 365 * 18));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
    );

    if (pickedDate != null) {
      final formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      setState(() => _birthday = formattedDate);
      CacheHelper.saveData(key: 'birthday', value: formattedDate);
      _updateProfile();
    }
  }

  void _showComingSoonMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }
}
