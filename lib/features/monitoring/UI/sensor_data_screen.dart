import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../../core/themes/app_colors.dart';
import '../../../shared/widgets/custom_botton.dart';
import '../../../shared/widgets/growth_rate_chart.dart';
import '../Logic/sensor_data_cubit.dart';

class SensorDataScreen extends StatefulWidget {
  final Map<String, String> field;

  const SensorDataScreen({super.key, required this.field});

  @override
  SensorDataScreenState createState() => SensorDataScreenState();
}

class SensorDataScreenState extends State<SensorDataScreen> {
  String _selectedSensor = 'EC';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: const CustomAppBar(
        title: 'Sensor Data',
        isHome: true,
      ),
      body: BlocBuilder<SensorDataCubit, SensorDataState>(
        builder: (context, state) {
          if (state is SensorDataInitial) {
            return _buildInitialState(context);
          } else if (state is SensorDataLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ));
          } else if (state is SensorDataLoaded) {
            return _buildLoadedState(context, state.data);
          } else if (state is SensorDataError) {
            return _buildErrorState(context, state.error);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
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
    String sensorKey;
    if (_selectedSensor == 'Humidity') {
      sensorKey = 'Hum';
    } else {
      sensorKey = _selectedSensor;
    }

    // Safely fetch the sensor value
    final sensorValue =
        data[sensorKey] ?? 0; // Fallback to 0 if the key is missing

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCircularGauge(sensorValue),
          const SizedBox(height: 16),
          _buildSensorSelection(),
          const SizedBox(height: 16),
          _buildChartSection(_selectedSensor),
          const SizedBox(
              height: 16), // Add space between the chart and the button
          CustomBottom(
            text: 'Refresh',
            onPressed: () => context.read<SensorDataCubit>().loadSensorData(),
          ),
          const SizedBox(height: 16),
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
              'Please check your internet connection',
              style: TextStyle(
                  fontFamily: 'SYNE',
                  fontSize: 18,
                  color: AppColors.blackColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularGauge(dynamic sensorValue) {
    final double displayValue = sensorValue is String
        ? double.tryParse(sensorValue) ?? 0
        : (sensorValue ?? 0).toDouble();

    return Column(
      children: [
        SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 100,
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: 0,
                  endValue: 100,
                  color: AppColors.primaryColor,
                ),
              ],
              pointers: <GaugePointer>[
                NeedlePointer(value: displayValue),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${displayValue.toStringAsFixed(1)}°',
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                      Text(_selectedSensor,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  positionFactor: 0.5,
                  angle: 90,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSensorSelection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSensorChip('EC', Icons.electric_bolt),
          _buildSensorChip('Fertility', Icons.eco),
          _buildSensorChip('Humidity', Icons.water_drop),
          _buildSensorChip('PH', Icons.science),
          _buildSensorChip('Temp', Icons.local_florist),
          _buildSensorChip('K', Icons.local_florist),
          _buildSensorChip('N', Icons.forest),
          _buildSensorChip('P', Icons.energy_savings_leaf),
        ],
      ),
    );
  }

  Widget _buildSensorChip(String label, IconData icon) {
    final isSelected = _selectedSensor == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSensor = label;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor:
                  isSelected ? AppColors.primaryColor : Colors.grey[300],
              child:
                  Icon(icon, color: isSelected ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(String selectedSensor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: GrowthRateChart(selectedSensor: selectedSensor),
      ),
    );
  }
}
