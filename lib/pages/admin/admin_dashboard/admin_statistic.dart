import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';

class AdminStatistic extends StatelessWidget {
  const AdminStatistic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1046,
      height: 100,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 20, left: 15),
      decoration: BoxDecoration(
          color: AppColors.foregroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          StatisticAllWidget(),
          StatisticsWidget(),
          StatisticsWidget(),
          StatisticsWidget(),
        ],
      ),
    );
  }
}

class StatisticAllWidget extends StatelessWidget {
  const StatisticAllWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.backgroundColor),
    );
  }
}

class StatisticsWidget extends StatelessWidget {
  const StatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      width: 274,
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.backgroundColor),
    );
  }
}
