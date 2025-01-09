import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/pages/admin/admin_dashboard/admin_calendar.dart';
import 'package:nazorat_varaqasi/pages/admin/admin_dashboard/admin_diagramm.dart';
import 'package:nazorat_varaqasi/pages/admin/admin_dashboard/admin_menu.dart';
import 'package:nazorat_varaqasi/pages/admin/admin_dashboard/admin_statistic.dart';
import 'package:nazorat_varaqasi/services/app_bar.dart';

import 'package:nazorat_varaqasi/style/app_colors.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Future<void> logout(BuildContext context) async {
    //   final prefs = await SharedPreferences.getInstance();
    //   await prefs.clear();
    //   Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    // }

    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(20),
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
                          Container(
                            width: 1046,
                            height: 260,
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.only(top: 20, left: 15),
                            decoration: BoxDecoration(
                                color: AppColors.foregroundColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text('data'),
                          )
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