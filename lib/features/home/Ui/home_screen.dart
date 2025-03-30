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
      backgroundColor: AppColors.whiteColor,
      child: Column(
        children: [
          const DrawerHeaderWidget(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.analytics_outlined,
                  title: 'Order Analytics',
                  subtitle: 'Performance insights & reports',
                  route: '/orderAnalytics',
                ),
                _buildDivider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.analytics_outlined,
                  title: 'Order Management',
                  subtitle: 'Order Management & tracking',
                  route: '/orderManagement',
                ),
                _buildDivider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.agriculture_outlined,
                  title: 'Crops Management',
                  subtitle: 'Crop cycles & planning',
                  route: '/cropsManagement',
                ),
                _buildDivider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.inventory_2_outlined,
                  title: 'Farm Inventory',
                  subtitle: 'Equipment & supplies tracking',
                  route: '/farmInventory',
                ),
                _buildDivider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.sensors_outlined,
                  title: 'Sensor Data',
                  subtitle: 'Real-time field metrics',
                  route: '/sensorData',
                ),
                _buildDivider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  route: '/settingsScreen',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: AppColors.primaryColor.withOpacity(0.1),
      indent: 56,
      endIndent: 16,
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required String route,
  }) {
    return Material(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: AppColors.primaryColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'SYNE',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'SYNE',
                  fontSize: 12,
                  color: AppColors.primaryColor.withOpacity(0.7),
                ),
              )
            : null,
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: AppColors.primaryColor.withOpacity(0.5),
        ),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.9),
            AppColors.primaryColor.withOpacity(0.7),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Image.asset(
              'assets/images/App_Logo.png',
              height: 80,
              width: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'AgroVision ',
            style: TextStyle(
              fontFamily: 'SYNE',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Farm Management Suite',
            style: TextStyle(
              fontFamily: 'SYNE',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
