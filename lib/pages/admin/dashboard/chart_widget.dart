import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.foregroundColor,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Статистика задач',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 10,
                      title: 'Активные',
                      color: Colors.orange,
                    ),
                    PieChartSectionData(
                      value: 20,
                      title: 'Завершённые',
                      color: Colors.green,
                    ),
                  ],
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
