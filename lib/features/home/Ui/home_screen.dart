import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:agro_vision/features/home/Logic/home_cubit.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../models/weather_model.dart';
import '../Logic/home_state.dart';
import 'widgets/quick_actions_grid.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getWeatherData();
  }

  Future<bool> _onWillPop() async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Exit'),
          content: const Text('Do you really want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(context),
        drawer: const AppDrawer(),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (BuildContext context, HomeState state) {
            if (state is HomeLoading) {
              return _buildSkeletonLoading();
            } else if (state is HomeLoaded) {
              return _buildBody(state.weather);
            } else if (state is HomeError) {
              return _buildErrorState(state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 1,
      shadowColor: Colors.black.withAlpha(10),
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
          icon: Icon(Icons.notifications_active, color: Colors.grey[800]),
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
              DevicesCard(sensors: sensors),
              const SizedBox(height: 24),
              _buildQuickActionsSection(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Icon(Iconsax.add5, size: 25, color: Colors.grey[800]),
              const SizedBox(width: 12),
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        const QuickActionsGrid(
          actions: [
            {
              'title': 'Crop Health',
              'icon': Icons.health_and_safety,
              'route': '/crop-health',
              'color1': '#65B073',
              'color2': '#3A8C47',
            },
            {
              'title': 'Tasks',
              'icon': Icons.task_alt,
              'route': '/allTasks',
              'color1': '#5BAE6A',
              'color2': '#4C8C5A',
            },
            {
              'title': 'Sensor Data',
              'icon': Icons.sensors,
              'route': '/sensorDataScreen',
              'color1': '#6BAEA3',
              'color2': '#3D8C7D',
            },
            {
              'title': 'Detection Records',
              'icon': Icons.auto_awesome,
              'route': '/detectionRecords',
              'color1': '#6BE697',
              'color2': '#5BB57A',
            },
          ],
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
          colors: [Color(0xff34C759), Color(0xff218838)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
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
                        color: Colors.white.withAlpha(230),
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
        color: Colors.black.withAlpha(38),
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

class DevicesCard extends StatelessWidget {
  final List<Map<String, dynamic>> sensors;

  const DevicesCard({super.key, required this.sensors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Devices",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          ...sensors.map((sensor) => _buildSensorRow(sensor)).toList(),
        ],
      ),
    );
  }

  Widget _buildSensorRow(Map<String, dynamic> sensor) {
    final status = sensor['status']?.toString() ?? '';
    final isActive = status.toLowerCase() == 'active';
    final statusColor = isActive ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${sensor['name']} ${sensor['id']}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: statusColor,
                ),
              ),
            ],
          ),
          if (!isActive && sensor['issue'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: Colors.orange.shade400,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    sensor['issue'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade400,
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> sensors = [
  {
    'id': '#SM201',
    'name': 'Soil Moisture Sensor',
    'type': 'moisture',
    'status': 'Active',
    // 'issue': 'Signal issue since 08:02 AM',
  },
];

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          const DrawerHeaderWidget(),
          ListTile(
            leading: const Icon(Icons.dataset, color: AppColors.primaryColor),
            title: const Text(
              'Farm Analytics',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: 'SYNE',
              ),
            ),
            onTap: () => Navigator.pushNamed(context, '/farmAnalytics'),
          ),
          ListTile(
            leading: const Icon(Icons.grass, color: AppColors.primaryColor),
            title: const Text(
              'Crops Management',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: 'SYNE',
              ),
            ),
            onTap: () => Navigator.pushNamed(context, '/cropsManagment'),
          ),
          ListTile(
            leading: const Icon(Icons.note_alt, color: AppColors.primaryColor),
            title: const Text(
              'Farm Inventory',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: 'SYNE',
              ),
            ),
            onTap: () => Navigator.pushNamed(context, '/farmInventory'),
          ),
          ListTile(
            leading: const Icon(Icons.data_thresholding,
                color: AppColors.primaryColor),
            title: const Text(
              'Sensor Data',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: 'SYNE',
              ),
            ),
            onTap: () => Navigator.pushNamed(context, '/sensorData'),
          ),
          ListTile(
            leading: const Icon(Icons.people_alt_rounded,
                color: AppColors.primaryColor),
            title: const Text(
              'Team',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: 'SYNE',
              ),
            ),
            onTap: () => Navigator.pushNamed(context, '/team'),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: AppColors.primaryColor),
            title: const Text(
              'Settings',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: 'SYNE',
              ),
            ),
            onTap: () => Navigator.pushNamed(context, '/settingsScreen'),
          ),
        ],
      ),
    );
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
    return DrawerHeader(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/field1.jpg'),
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
              child: Container(color: Colors.white.withAlpha(128)),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 1.5),
              child: Container(color: Colors.black.withAlpha(25)),
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
