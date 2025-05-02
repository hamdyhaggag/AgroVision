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
          const SnackBar(
            content: Text('Email is required',
                style: TextStyle(color: AppColors.surface)),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final formData = FormData.fromMap({
        'name': username,
        'email': validEmail,
        'phone': _phone,
        'birthday': _birthday,
        if (_profileImage != null)
          'img': await MultipartFile.fromFile(
            _profileImage!.path,
            filename: _profileImage!.path.split('/').last,
          ),
      });

      final response = await _apiService.updateAccount(formData);

      if (response.data.message.contains('successfully')) {
        setState(() {
          _updateProfileImage();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data.message),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      }
    } catch (e) {
      String errorMessage = 'Profile update failed';
      if (e is DioException && e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        errorMessage = errors?.entries.first.value.first ?? errorMessage;
      } else if (e is DioException && e.response?.statusCode == 401) {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
          return;
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
          ),
        );
      }
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
      CacheHelper.profileImageNotifier.value = pickedFile.path;
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      await _updateProfile();
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium_rounded,
                    color: AppColors.accentColor, size: 18),
                SizedBox(width: 6),
                Text(
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
        icon: const Icon(Icons.edit, size: 20, color: AppColors.primaryColor),
        onPressed: () {
          if (title == 'Full Name') {
            _nameController.text = username;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Edit Full Name'),
                content: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.trim().isNotEmpty) {
                        setState(() => username = _nameController.text.trim());
                        _updateProfile();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          } else {
            onEdit();
          }
        },
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
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 16, color: AppColors.divider),
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
            onPressed: () {
              controller.dispose();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => _phone = controller.text.trim());
                CacheHelper.saveData(key: 'phone', value: _phone);
                _updateProfile();
                controller.dispose();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) {
      // Ensure controller is disposed even if dialog is dismissed by tapping outside
      controller.dispose();
    });
  }

  Future<void> _showBirthdayPicker() async {
    DateTime? initialDate;
    try {
      if (_birthday != null && _birthday!.isNotEmpty) {
        final parts = _birthday!.split('-');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
      }
    } catch (e) {
      debugPrint('Error parsing birthday: $e');
    }

    initialDate ??= DateTime.now().subtract(const Duration(days: 365 * 18));

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
