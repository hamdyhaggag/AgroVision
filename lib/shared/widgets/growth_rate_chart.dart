import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GrowthRateChart extends StatelessWidget {
  const GrowthRateChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Growth rate',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('0.75',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ToggleButtons(
                isSelected: const [true, false, false],
                onPressed: (index) {},
                children: const [
                  Text('W'),
                  Text('M'),
                  Text('Y'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: [
                  for (int i = 0; i < 12; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                            toY: (i % 3 == 0 ? 1.0 : 0.5), color: Colors.green),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
