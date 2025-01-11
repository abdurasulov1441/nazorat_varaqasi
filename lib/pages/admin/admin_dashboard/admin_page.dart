import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/services/acepted_cars.dart';
import 'package:nazorat_varaqasi/services/app_bar.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';

import 'dashboard_page/admin_menu.dart';

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
                      AceptedCards()
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
