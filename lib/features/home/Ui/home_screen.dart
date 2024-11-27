import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';
import '../../../shared/widgets/fields_widget.dart';
import '../../../shared/widgets/notes_list_widget.dart';
import '../../../shared/widgets/weather_widget.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = _getNotes();
    final fields = someFieldsList();

    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: const AppDrawer(),
      body: _buildBody(notes, fields),
    );
  }

  // AppBar Widget
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primaryColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/user.png'),
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
          NotesListWidget(notes: notes, onAddNote: () => print('Add Note')),
          const SizedBox(height: 18),
          FieldsWidget(fields: fields),
        ],
      ),
    );
  }

  // Dummy Data
  List<Map<String, String>> _getNotes() => [
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
          ..._buildDrawerItems(),
        ],
      ),
    );
  }

  List<Widget> _buildDrawerItems() {
    return const [
      DrawerItem(icon: Icons.dataset, label: 'Farm Analytics'),
      DrawerItem(icon: Icons.grass, label: 'Crops Management'),
      DrawerItem(icon: Icons.note_alt, label: 'Farm Inventory'),
      DrawerItem(icon: Icons.data_thresholding, label: 'Sensor Data'),
      DrawerItem(icon: Icons.people_alt_rounded, label: 'Team'),
      DrawerItem(icon: Icons.settings, label: 'Settings'),
    ];
  }
}

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/header_background.jpg'),
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
          Center(
            child: Text(
              'AgroVision',
              style: TextStyle(
                color: AppColors.whiteColor,
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

  const DrawerItem({
    required this.icon,
    required this.label,
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
    );
  }
}
