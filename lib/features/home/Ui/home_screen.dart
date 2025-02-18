import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:agro_vision/features/home/Logic/home_cubit.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../models/weather_model.dart';
import '../../../shared/widgets/fields_widget.dart';
import '../../../shared/widgets/notes_list_widget.dart';
import '../Logic/home_state.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
      key: _scaffoldKey,
      appBar: _buildAppBar(context),
      drawer: AppDrawer(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) return _buildSkeletonLoading();
          if (state is HomeLoaded) return _buildBody(state.weather);
          if (state is HomeError) return _buildErrorState(state.message);
          return const SizedBox.shrink();
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      surfaceTintColor: Colors.white,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.primaryColor),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            _buildAppBarActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarActions() {
    return Row(
      children: [
        IconButton(
          icon: Badge(
            smallSize: 10,
            backgroundColor: AppColors.primaryColor,
            child: Icon(Icons.notifications_active, color: Colors.grey[800]),
          ),
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.notificationsScreen),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => Navigator.pushNamed(context, AppRoutes.profileScreen),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryColor, width: 1.5),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(WeatherModel weather) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildWeatherSection(weather),
              const SizedBox(height: 24),
              FieldsWidget(fields: fields),
              const SizedBox(height: 24),
              NotesListWidget(notes: notes, onAddNote: _navigateToAddNote),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherSection(WeatherModel weather) {
    return Container(
      height: 290,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff34C759),
            Color(0xff218838),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 20,
            top: 20,
            child: Lottie.asset(
              _getWeatherAnimation(weather.weather.first.main),
              width: 80,
              height: 80,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 330),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_pin,
                          color: Colors.white70, size: 20),
                      Text(' ${weather.name}, ${weather.sys.country}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text('${weather.main.temp.round()}°C',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        height: 0.9,
                      )),
                  const SizedBox(height: 8),
                  Text(_getWeatherCondition(weather.weather.first.main),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                      )),
                  const SizedBox(height: 20),
                  _buildWeatherMetrics(weather),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherMetrics(WeatherModel weather) {
    return SizedBox(
      height: 120,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 12,
        children: [
          _buildMetricItem(
              Icons.water_drop, 'Humidity', '${weather.main.humidity}%'),
          _buildMetricItem(Icons.air, 'Wind', '${weather.wind.speed} m/s'),
          _buildMetricItem(
              Icons.speed, 'Pressure', '${weather.main.pressure} hPa'),
          _buildMetricItem(Icons.visibility, 'Visibility',
              '${(weather.visibility / 1000).round()} km'),
        ],
      ),
    );
  }

  Widget _buildMetricItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white70, size: 18),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animations/error.json', width: 150),
              const SizedBox(height: 20),
              Text(message,
                  style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => context.read<HomeCubit>().getWeatherData(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getWeatherCondition(String condition) {
    return condition.replaceAll('_', ' ').toUpperCase();
  }

  void _navigateToAddNote() {
    Navigator.pushNamed(context, AppRoutes.addNewNote);
  }

  String _getWeatherAnimation(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'assets/animations/weather/sunny.json';
      case 'rain':
        return 'assets/animations/weather/rain.json';
      case 'clouds':
        return 'assets/animations/weather/cloudy.json';
      case 'thunderstorm':
        return 'assets/animations/weather/thunderstorm.json';
      case 'snow':
        return 'assets/animations/weather/snow.json';
      default:
        return 'assets/animations/weather/weather.json';
    }
  }
}

List<Map<String, String>> someNotesList() => [
      {
        'image': 'assets/images/note1.jpg',
        'date': 'Dec 24 • 5:43 pm',
        'content': 'Excellent harvest...',
        'location': 'North Field'
      },
      {
        'image': 'assets/images/note2.jpg',
        'date': 'May 22 • 3:17 pm',
        'content': 'I’ll be back in...',
        'location': 'Greenhouse A'
      },
      {
        'image': 'assets/images/note3.jpg',
        'date': 'Jun 22 • 5:24 pm',
        'content': 'I’ll be back in...',
        'location': 'Storage Area'
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
      if (mounted) {
        setState(() {
          _showShimmer = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = CacheHelper.getString(key: 'drawerImagePath');
    ImageProvider backgroundImage = imagePath.isNotEmpty
        ? AssetImage(imagePath)
        : const AssetImage('assets/images/field1.jpg');

    return DrawerHeader(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: backgroundImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _showShimmer ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 1.5),
              child: Container(
                color: Colors.black.withValues(alpha: 0.1),
              ),
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
