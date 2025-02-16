import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agro_vision/features/home/Logic/home_cubit.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../main.dart' as weatherData;
import '../../../models/weather_model.dart';
import '../../../shared/widgets/fields_widget.dart';
import '../../../shared/widgets/notes_list_widget.dart';
import '../../../shared/widgets/weather_widget.dart';
import '../Logic/home_state.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> notes = someNotesList();
  final List<Map<String, String>> fields = someFieldsList();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: const AppDrawer(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) return _buildLoadingBody();
          if (state is HomeLoaded) return _buildContentBody(state.weather);
          if (state is HomeError) return Center(child: Text(state.message));
          return const SizedBox.shrink();
        },
      ),
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

  Widget _buildLoadingBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildWeatherShimmer(),
          const SizedBox(height: 5),
          NotesListWidget(
              notes: notes,
              onAddNote: () =>
                  Navigator.pushNamed(context, AppRoutes.addNewNote)),
          const SizedBox(height: 18),
          FieldsWidget(fields: fields),
        ],
      ),
    );
  }

  Widget _buildContentBody(WeatherModel weather) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          WeatherWidget(weather: weather),
          const SizedBox(height: 5),
          NotesListWidget(
              notes: notes,
              onAddNote: () =>
                  Navigator.pushNamed(context, AppRoutes.addNewNote)),
          const SizedBox(height: 18),
          FieldsWidget(fields: fields),
        ],
      ),
    );
  }

  Widget _buildWeatherShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

List<Map<String, String>> someNotesList() => [
      {
        'image': 'assets/images/note1.jpg',
        'date': 'Dec 24 • 5:43 pm',
        'content': 'Excellent harvest...'
      },
      {
        'image': 'assets/images/note2.jpg',
        'date': 'May 22 • 3:17 pm',
        'content': 'I’ll be back in...'
      },
      {
        'image': 'assets/images/note3.jpg',
        'date': 'Jun 22 • 5:24 pm',
        'content': 'I’ll be back in...'
      },
    ];

List<Map<String, String>> someFieldsList() => [
      {
        'image': 'assets/images/field5.jpg',
        'name': 'Empty Fields',
        'size': '14 ha',
        'type': 'Tomato'
      },
      {
        'image': 'assets/images/field4.jpg',
        'name': 'Tomato Fields',
        'size': '11 ha',
        'type': 'Tomato'
      },
      {
        'image': 'assets/images/field3.jpg',
        'name': 'Potato Field 1',
        'size': '10 ha',
        'type': 'Potato'
      },
      {
        'image': 'assets/images/field2.jpg',
        'name': 'Potato Field 2',
        'size': '10 ha',
        'type': 'Potato'
      },
    ];

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(children: [
        const DrawerHeaderWidget(),
        ..._buildDrawerItems(context)
      ]),
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    return [
      DrawerItem(
          icon: Icons.dataset,
          label: 'Farm Analytics',
          onTap: () => Navigator.pushNamed(context, '/farmAnalytics-chat')),
      DrawerItem(
          icon: Icons.grass,
          label: 'Crops Management',
          onTap: () => Navigator.pushNamed(context, '/cropsManagment-chat')),
      DrawerItem(
          icon: Icons.note_alt,
          label: 'Farm Inventory',
          onTap: () => Navigator.pushNamed(context, '/farmInventory-chat')),
      DrawerItem(
          icon: Icons.data_thresholding,
          label: 'Sensor Data',
          onTap: () => Navigator.pushNamed(context, '/sensorData')),
      DrawerItem(
          icon: Icons.people_alt_rounded,
          label: 'Team',
          onTap: () => Navigator.pushNamed(context, '/team')),
      DrawerItem(
          icon: Icons.settings,
          label: 'Settings',
          onTap: () => Navigator.pushNamed(context, '/settingsScreen')),
    ];
  }
}

class DrawerHeaderWidget extends StatefulWidget {
  const DrawerHeaderWidget({super.key});

  @override
  DrawerHeaderWidgetState createState() => DrawerHeaderWidgetState();
}

class DrawerHeaderWidgetState extends State<DrawerHeaderWidget> {
  bool _showShimmer = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showShimmer = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = CacheHelper.getString(key: 'drawerImagePath');
    final backgroundImage = imagePath.isNotEmpty
        ? AssetImage(imagePath)
        : const AssetImage('assets/images/field1.jpg');

    return DrawerHeader(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: backgroundImage, fit: BoxFit.cover)),
            child: AnimatedOpacity(
              opacity: _showShimmer ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(color: Colors.white.withOpacity(0.5)),
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

  const DrawerItem(
      {required this.icon,
      required this.label,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(label,
          style: const TextStyle(
              color: AppColors.primaryColor,
              fontFamily: 'SYNE',
              fontWeight: FontWeight.w400)),
      onTap: onTap,
    );
  }
}
