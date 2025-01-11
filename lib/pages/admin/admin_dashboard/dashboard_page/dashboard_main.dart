import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/pages/admin/admin_dashboard/dashboard_page/admin_calendar.dart';
import 'package:nazorat_varaqasi/pages/admin/admin_dashboard/dashboard_page/admin_diagramm.dart';
import 'package:nazorat_varaqasi/pages/admin/admin_dashboard/dashboard_page/admin_search.dart';
import 'package:nazorat_varaqasi/pages/admin/admin_dashboard/dashboard_page/admin_statistic.dart';

class DashboardMain extends StatelessWidget {
  const DashboardMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdminStatistic(),
        Row(
          children: [AdminDiagramm(), AdminCalendar()],
        ),
        AdminSearch()
      ],
    );
  }
}
