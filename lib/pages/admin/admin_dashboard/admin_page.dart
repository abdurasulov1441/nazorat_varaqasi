import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/pages/admin/admin_dashboard/dashboard_page/admin_calendar.dart';
import 'package:nazorat_varaqasi/pages/admin/admin_dashboard/dashboard_page/admin_diagramm.dart';
import 'package:nazorat_varaqasi/pages/admin/admin_dashboard/dashboard_page/admin_menu.dart';
import 'package:nazorat_varaqasi/pages/admin/admin_dashboard/dashboard_page/admin_search.dart';
import 'package:nazorat_varaqasi/pages/admin/admin_dashboard/dashboard_page/admin_statistic.dart';
import 'package:nazorat_varaqasi/services/app_bar.dart';

import 'package:nazorat_varaqasi/style/app_colors.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              MyCustomAppBar(),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [AdminMenu()],
                      ),
                      Column(
                        children: [
                          AdminStatistic(),
                          Row(
                            children: [AdminDiagramm(), AdminCalendar()],
                          ),
                          AdminSearch()
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
