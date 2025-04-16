import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/monitoring/UI/sensor_data_screen.dart';

class GrowthRateChart extends StatelessWidget {
  final String selectedSensor;
  final ChartStyle chartStyle;

  const GrowthRateChart({
    super.key,
    required this.selectedSensor,
    this.chartStyle = const ChartStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 20,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: chartStyle.gridColor,
              strokeWidth: 0.5,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: chartStyle.gridColor,
              strokeWidth: 0.5,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => BottomTitleWidget(
                  value: value,
                  meta: meta,
                  style: chartStyle,
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => LeftTitleWidget(
                  value: value,
                  meta: meta,
                  style: chartStyle,
                ),
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: chartStyle.borderColor,
              width: 1,
            ),
          ),
          minX: 0,
          maxX: 24,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: _generateSampleData(),
              isCurved: true,
              color: chartStyle.lineColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    chartStyle.lineColor.withValues(alpha: 0.3),
                    chartStyle.lineColor.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchSpot) => chartStyle.backgroundColor,
              getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)}%',
                  TextStyle(
                    color: chartStyle.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
            handleBuiltInTouches: true,
          ),
        ),
      ),
    );
  }

  List<FlSpot> _generateSampleData() {
    return List.generate(25, (index) {
      final x = index.toDouble();
      final y = (60 + 30 * sin(x * 0.5)).toDouble();
      return FlSpot(x, y);
    });
  }
}

class LeftTitleWidget extends StatelessWidget {
  final double value;
  final TitleMeta meta;
  final ChartStyle style;

  const LeftTitleWidget({
    super.key,
    required this.value,
    required this.meta,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${value.toInt()}%',
      style: TextStyle(
        color: style.textColor,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.left,
    );
  }
}

class BottomTitleWidget extends StatelessWidget {
  final double value;
  final TitleMeta meta;
  final ChartStyle style;

  const BottomTitleWidget({
    super.key,
    required this.value,
    required this.meta,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0.h),
      child: Text(
        '${value.toInt()}:00',
        style: TextStyle(
          color: style.textColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
