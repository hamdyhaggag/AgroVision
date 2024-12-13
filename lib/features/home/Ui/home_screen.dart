import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../shared/widgets/fields_widget.dart';
import '../../../shared/widgets/notes_list_widget.dart';
import '../../../shared/widgets/weather_widget.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = someNotesList();
    final fields = someFieldsList();

    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: const AppDrawer(),
      body: _buildBody(notes, fields),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primaryColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_active_rounded,
                    color: Colors.white),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.notificationsScreen),
              ),
            ],
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, AppRoutes.profileScreen),
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
          ),
        ],
      ),
    );
  }

  // Body Widget
  Widget _buildBody(
      List<Map<String, String>> notes, List<Map<String, String>> fields) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const WeatherWidget(
            location: 'Alexandria,Egypt',
            temperature: '+17°C',
            weatherIcon: 'assets/icon/cloudy.png',
            additionalInfo: {
              'Humidity': '30%',
              'Precipitation': '5.1ml',
              'Pressure': '450hPa',
              'Wind': '23m/s',
            },
          ),
          const SizedBox(height: 5),
          Builder(builder: (context) {
            return NotesListWidget(
              notes: notes,
              onAddNote: () =>
                  Navigator.pushNamed(context, AppRoutes.addNewNote),
            );
          }),
          const SizedBox(height: 18),
          FieldsWidget(fields: fields),
        ],
      ),
    );
  }

  // Dummy Data
  List<Map<String, String>> someNotesList() => [
        {
          'image': 'assets/images/field.png',
          'date': 'May 24 • 5:43 pm',
          'content': 'Excellent harvest...',
        },
        {
          'image': 'assets/images/field.png',
          'date': 'May 22 • 3:17 pm',
          'content': 'I’ll be back in...',
        },
      ];

  List<Map<String, String>> someFieldsList() => [
        {
          'image': 'assets/images/field.png',
          'name': 'Empty Fields',
          'size': '14 ha',
          'type': 'Grapes',
        },
        {
          'image': 'assets/images/field.png',
          'name': 'Grape Fields',
          'size': '11 ha',
          'type': 'Grapes',
        },
        {
          'image': 'assets/images/field.png',
          'name': 'Empty Fields',
          'size': '10 ha',
          'type': 'Grapes',
        },
        {
          'image': 'assets/images/field.png',
          'name': 'Grape Fields',
          'size': '10 ha',
          'type': 'Grapes',
        },
      ];
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          const DrawerHeaderWidget(),
          ..._buildDrawerItems(context),
        ],
      ),
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    return [
      DrawerItem(
        icon: Icons.dataset,
        label: 'Farm Analytics',
        onTap: () => Navigator.pushNamed(context, '/farmAnalytics-chat'),
      ),
      DrawerItem(
        icon: Icons.grass,
        label: 'Crops Management',
        onTap: () => Navigator.pushNamed(context, '/cropsManagment-chat'),
      ),
      DrawerItem(
        icon: Icons.note_alt,
        label: 'Farm Inventory',
        onTap: () => Navigator.pushNamed(context, '/farmInventory-chat'),
      ),
      DrawerItem(
        icon: Icons.data_thresholding,
        label: 'Sensor Data',
        onTap: () => Navigator.pushNamed(context, '/sensorData'),
      ),
      DrawerItem(
        icon: Icons.people_alt_rounded,
        label: 'Team',
        onTap: () => Navigator.pushNamed(context, '/team'),
      ),
      DrawerItem(
        icon: Icons.settings,
        label: 'Settings',
        onTap: () => Navigator.pushNamed(context, '/settingsScreen'),
      ),
    ];
  }
}

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String imagePath = CacheHelper.getString(key: 'drawerImagePath');

    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imagePath.isNotEmpty
              ? AssetImage(imagePath)
              : const AssetImage('assets/images/header_background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 1.5),
              child: Container(color: Colors.black.withOpacity(0.1)),
            ),
          ),
          const Center(
            child: Text(
              'AgroVision',
              style: TextStyle(
                color: Colors.white,
                fontSize: 45,
                fontFamily: 'SYNE',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(
        label,
        style: const TextStyle(
          color: AppColors.primaryColor,
          fontFamily: 'SYNE',
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: onTap,
    );
  }
}
