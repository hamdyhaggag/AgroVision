import 'package:agro_vision/shared/widgets/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/themes/app_colors.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/growth_rate_chart.dart';
import '../Logic/sensor_data_cubit.dart';

class SensorDataScreen extends StatelessWidget {
  final Map<String, String> field;

  const SensorDataScreen({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: _buildCustomAppBar(),
      body: BlocBuilder<SensorDataCubit, SensorDataState>(
        builder: (context, state) {
          if (state is SensorDataInitial) {
            return _buildInitialState(context);
          } else if (state is SensorDataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SensorDataLoaded) {
            return _buildLoadedState(context, state.data);
          } else if (state is SensorDataError) {
            return _buildErrorState(context, state.error);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: BlocBuilder<SensorDataCubit, SensorDataState>(
        builder: (context, state) {
          if (state is! SensorDataInitial) {
            return CustomBottom(
              text: 'Refresh',
              onPressed: () {
                context.read<SensorDataCubit>().loadSensorData();
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return const CustomAppBar(title: 'Sensor Dashboard');
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/empty_state.svg', height: 300),
          const SizedBox(height: 20),
          const Text(
            'No data available yet!',
            style:
                TextStyle(fontSize: 18, color: Colors.grey, fontFamily: 'SYNE'),
          ),
          const SizedBox(height: 20),
          CustomBottom(
            text: 'Load Data',
            onPressed: () => context.read<SensorDataCubit>().loadSensorData(),
          )
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, Map<String, dynamic> data) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 16),
          _buildStatCards(data),
          const SizedBox(height: 16),
          _buildChartSection(),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/error_state.svg', height: 300),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Please check your internet connection ',
              style: TextStyle(
                  fontFamily: 'SYNE',
                  fontSize: 18,
                  color: AppColors.blackColor),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1D976C), Color(0xFF93F9B9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to the Sensor Dashboard!',
            style: TextStyle(
              fontFamily: 'SYNE',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          StatCard(
            title: 'EC',
            value: data['EC']?.toString() ?? 'N/A',
            icon: Icons.electric_bolt,
          ),
          StatCard(
            title: 'Fertility',
            value: data['Fertility']?.toString() ?? 'N/A',
            icon: Icons.eco,
          ),
          StatCard(
            title: 'Humidity',
            value: data['Hum']?.toString() ?? 'N/A',
            icon: Icons.water_drop,
          ),
          StatCard(
            title: 'K',
            value: data['K']?.toString() ?? 'N/A',
            icon: Icons.local_florist,
          ),
          StatCard(
            title: 'N',
            value: data['N']?.toString() ?? 'N/A',
            icon: Icons.forest,
          ),
          StatCard(
            title: 'P',
            value: data['P']?.toString() ?? 'N/A',
            icon: Icons.energy_savings_leaf,
          ),
          StatCard(
            title: 'PH',
            value: data['PH']?.toString() ?? 'N/A',
            icon: Icons.science,
          ),
          StatCard(
            title: 'Temperature',
            value: data['Temp']?.toString() ?? 'N/A',
            icon: Icons.thermostat,
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const GrowthRateChart(),
      ),
    );
  }
}
