import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/pages/admin/dashboard/chart_widget.dart';
import 'package:nazorat_varaqasi/pages/admin/dashboard/user_list.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          flex: 1,
          child: UserListWidget(),
        ),
        Expanded(
          flex: 3,
          child: ChartWidget(),
        ),
      ],
    );
  }
}
