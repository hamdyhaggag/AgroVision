import 'dart:math';
import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  Map<String, Map<String, bool>> pumpControls = {
    'EC': {'auto': false, 'manual': false},
    'Fertility': {'auto': false, 'manual': false},
    'Humidity': {'auto': false, 'manual': false},
    'PH': {'auto': false, 'manual': false},
    'Temp': {'auto': false, 'manual': false},
    'K': {'auto': false, 'manual': false},
    'N': {'auto': false, 'manual': false},
    'P': {'auto': false, 'manual': false},
  };
  final List<Map<String, String>> sensors = [
    {'label': 'EC', 'svgPath': 'assets/images/sensor_icon/Ec.svg'},
    {
      'label': 'Fertility',
      'svgPath': 'assets/images/sensor_icon/Fertility.svg'
    },
    {'label': 'Humidity', 'svgPath': 'assets/images/sensor_icon/Humidity.svg'},
    {'label': 'PH', 'svgPath': 'assets/images/sensor_icon/Ph.svg'},
    {'label': 'Temp', 'svgPath': 'assets/images/sensor_icon/Temp.svg'},
    {'label': 'K', 'svgPath': 'assets/images/sensor_icon/K.svg'},
    {'label': 'N', 'svgPath': 'assets/images/sensor_icon/N.svg'},
    {'label': 'P', 'svgPath': 'assets/images/sensor_icon/P.svg'},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const CustomAppBar(title: 'Sensor Data', isHome: true),
      body: BlocBuilder<SensorDataCubit, SensorDataState>(
        builder: (context, state) {
          if (state is SensorDataInitial) return _buildInitialState(context);
          if (state is SensorDataLoading) return _buildLoadingState();
          if (state is SensorDataLoaded) {
            return _buildLoadedState(context, state.data);
          }
          if (state is SensorDataError) {
            return _buildErrorState(context, state.error);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/empty_state.svg', height: 200),
            const SizedBox(height: 32),
            Text(
              'No Sensor Data Available',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SYNE',
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Get started by loading sensor data',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textTertiary,
                fontFamily: 'SYNE',
              ),
            ),
            const SizedBox(height: 32),
            CustomBottom(
              text: 'LOAD DATA',
              onPressed: () => context.read<SensorDataCubit>().loadSensorData(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ShimmerLoader(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildShimmerGauge(),
            const SizedBox(height: 24),
            _buildShimmerGrid(),
            const SizedBox(height: 24),
            _buildShimmerChart(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, Map<String, dynamic> data) {
    final sensorValue = _getSensorValue(data, _selectedSensor);
    return RefreshIndicator(
      onRefresh: () => context.read<SensorDataCubit>().loadSensorData(),
      color: AppColors.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildGaugeCard(sensorValue),
            const SizedBox(height: 24),
            _buildSensorGrid(),
            const SizedBox(height: 24),
            _buildPumpControlsSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGauge() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 150,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.gaugeBackground,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 220,
              decoration: const BoxDecoration(
                color: AppColors.gaugeBackground,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: 8,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: AppColors.gaugeBackground,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildShimmerChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.gaugeBackground,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildGaugeCard(double value) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Current Reading',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontFamily: 'SYNE',
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: value / 100),
                duration: const Duration(milliseconds: 800),
                builder: (context, normalizedValue, child) {
                  return CustomPaint(
                    painter: _GaugePainter(normalizedValue),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 32,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            _selectedSensor,
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  AppColors.textPrimary.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: sensors.length,
      itemBuilder: (context, index) {
        final sensor = sensors[index];
        return _buildSensorItem(
          label: sensor['label'] as String,
          svgPath: sensor['svgPath'] as String,
        );
      },
    );
  }

  Widget _buildSensorItem({required String label, required String svgPath}) {
    final isSelected = _selectedSensor == label;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _selectedSensor = label),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    svgPath,
                    colorFilter: ColorFilter.mode(
                      isSelected ? Colors.white : AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontSize: 12,
                    fontFamily: 'SYNE',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPumpControlsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.textSecondary.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icon/control.svg',
                    colorFilter: const ColorFilter.mode(
                        AppColors.primaryColor, BlendMode.srcIn),
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Smart Pump Control',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          fontFamily: 'SYNE',
                        ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.black12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: _buildControlItem(
                label: _selectedSensor,
                svgPath: sensors.firstWhere(
                    (sensor) => sensor['label'] == _selectedSensor)['svgPath']!,
                autoActive: pumpControls[_selectedSensor]!['auto']!,
                manualActive: pumpControls[_selectedSensor]!['manual']!,
                onAutoChanged: (value) {
                  setState(() {
                    pumpControls[_selectedSensor]!['auto'] = value;
                    if (value) pumpControls[_selectedSensor]!['manual'] = false;
                  });
                },
                onManualChanged: (value) {
                  setState(() {
                    pumpControls[_selectedSensor]!['manual'] = value;
                    if (value) pumpControls[_selectedSensor]!['auto'] = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlItem({
    required String label,
    required String svgPath,
    required bool autoActive,
    required bool manualActive,
    required ValueChanged<bool> onAutoChanged,
    required ValueChanged<bool> onManualChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor.withValues(alpha: 0.03),
              AppColors.primaryColor.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  svgPath,
                  width: 28,
                  height: 28,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontFamily: 'SYNE',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      autoActive
                          ? 'Auto Mode'
                          : manualActive
                              ? 'Manual '
                              : 'Inactive',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                        fontFamily: 'SYNE',
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusIndicator(autoActive, manualActive),
              const SizedBox(width: 24),
              Column(
                children: [
                  _buildControlButton(
                    label: 'Auto',
                    active: autoActive,
                    activeColor: AppColors.primaryColor,
                    icon: Icons.auto_awesome_mosaic_rounded,
                    onTap: () => onAutoChanged(!autoActive),
                  ),
                  const SizedBox(height: 8),
                  _buildControlButton(
                    label: 'Manual',
                    active: manualActive,
                    activeColor: AppColors.primaryColor,
                    icon: Icons.touch_app_rounded,
                    onTap: () => onManualChanged(!manualActive),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(bool autoActive, bool manualActive) {
    Color indicatorColor = Colors.grey;
    if (autoActive) indicatorColor = AppColors.primaryColor;
    if (manualActive) indicatorColor = AppColors.primaryColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: indicatorColor,
        shape: BoxShape.circle,
        boxShadow: [
          if (autoActive || manualActive)
            BoxShadow(
              color: indicatorColor.withValues(alpha: 0.4),
              spreadRadius: 2,
              blurRadius: 8,
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String label,
    required bool active,
    required Color activeColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              active ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? activeColor : Colors.grey.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 18,
                color:
                    active ? activeColor : Colors.grey.withValues(alpha: 0.6)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: active ? activeColor : Colors.grey,
                fontFamily: 'SYNE',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/error_state.svg', height: 200),
            const SizedBox(height: 32),
            Text(
              'Connection Error',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.errorColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SYNE',
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to fetch sensor data. Please check your internet connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textTertiary,
                fontFamily: 'SYNE',
              ),
            ),
            const SizedBox(height: 32),
            CustomBottom(
              text: 'Retry',
              onPressed: () => context.read<SensorDataCubit>().loadSensorData(),
              color: AppColors.errorColor,
            )
          ],
        ),
      ),
    );
  }

  double _getSensorValue(Map<String, dynamic> data, String sensor) {
    final sensorKey = sensor == 'Humidity' ? 'Hum' : sensor;
    final value = data[sensorKey] ?? 0;
    return value is String ? double.tryParse(value) ?? 0 : value.toDouble();
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  _GaugePainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) / 2) * 0.8;
    final backgroundPaint = Paint()
      ..color = AppColors.gaugeBackground
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;
    canvas.drawCircle(center, radius, backgroundPaint);
    final actualValue = progress * 100;
    final arcColor = actualValue < 40
        ? AppColors.warningColor
        : actualValue < 80
            ? AppColors.primaryColor
            : AppColors.successColor;
    final progressPaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ShimmerLoader extends StatefulWidget {
  final Widget child;
  const ShimmerLoader({super.key, required this.child});
  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _opacityAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                AppColors.gaugeBackground.withValues(alpha: 0.9),
                AppColors.gaugeBackground.withValues(alpha: 0.6),
                AppColors.gaugeBackground.withValues(alpha: 0.9),
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds),
            child: widget.child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class ChartStyle {
  final Color backgroundColor;
  final Color textColor;
  final Color lineColor;
  final Color axisLineColor;
  final Color gridColor;
  final Color borderColor;

  const ChartStyle({
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.lineColor = Colors.blue,
    this.axisLineColor = Colors.grey,
    this.gridColor = Colors.grey,
    this.borderColor = Colors.transparent,
  });
}
