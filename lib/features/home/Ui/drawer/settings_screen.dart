import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/themes/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: AppColors.primaryColor, width: 4.0),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/user.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Ahmed Ali',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SYNE',
                      ),
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

            // Settings List
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
