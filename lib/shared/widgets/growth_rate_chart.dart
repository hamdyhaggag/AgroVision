import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GrowthRateChart extends StatelessWidget {
  const GrowthRateChart({super.key, required this.selectedSensor});

  // Dynamic sensor name passed to the widget
  final String selectedSensor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          SizedBox(height: 8.h),
          _buildHighlightedGrowthRateSection(),
          SizedBox(height: 16.h),
          _buildBarChart(),
          _buildBottomLegend(),
        ],
      ),
    );
  }

  // Builds the title section dynamically based on the selectedSensor.
  Widget _buildTitle() {
    return Row(
      children: [
        Icon(Icons.bar_chart, color: Colors.green, size: 24.sp),
        SizedBox(width: 8.w),
        Text(
          '$selectedSensor Rate',
          style: TextStyle(
            fontFamily: 'SYNE',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade800,
          ),
        ),
      ],
    );
  }

  // Builds the section displaying the highlighted growth rate and toggle buttons.
  Widget _buildHighlightedGrowthRateSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.green.shade300, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '0.75%',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              Text(
                'Weekly Rate',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          ToggleButtons(
            isSelected: const [true, false, false],
            onPressed: (index) {
              // TODO: Implement toggle functionality
            },
            borderRadius: BorderRadius.circular(8.r),
            fillColor: Colors.green.withOpacity(0.2),
            selectedColor: Colors.green.shade900,
            color: Colors.black54,
            constraints: BoxConstraints(
              minWidth: 40.w,
              minHeight: 36.h,
            ),
            children: const [
              Text('W'),
              Text('M'),
              Text('Y'),
            ],
          ),
        ],
      ),
    );
  }

  // Builds the bar chart displaying growth rate data.
  Widget _buildBarChart() {
    return SizedBox(
      height: 220.h,
      child: BarChart(
        BarChartData(
          maxY: 1.5,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.shade300,
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40.w,
                getTitlesWidget: (value, meta) => Text(
                  '${(value * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    _getMonthLabel(value.toInt()),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
          ),
          barGroups: List.generate(12, (index) => _buildBarGroup(index)),
        ),
      ),
    );
  }

  // Builds each bar group for the bar chart.
  BarChartGroupData _buildBarGroup(int index) {
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: (index % 4 == 0 ? 1.2 : 0.8),
          width: 12.w,
          gradient: LinearGradient(
            colors: [
              Colors.green.shade400,
              Colors.green.shade700,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(8.r),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 1.5,
            color: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }

  // Returns the month label based on the index.
  String _getMonthLabel(int index) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[index % months.length];
  }

  // Builds the bottom legend displaying growth rate labels.
  Widget _buildBottomLegend() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Lowest Rate',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black54,
            ),
          ),
          Text(
            'Highest Rate',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
