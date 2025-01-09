import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/services/menu_button.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';

class AdminMenu extends StatelessWidget {
  const AdminMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 20),
      width: 250,
      height: 600,
      decoration: BoxDecoration(
          color: AppColors.foregroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          AdminMenuButton(),
          SizedBox(
            height: 5,
          ),
          AdminMenuButton(),
          SizedBox(
            height: 5,
          ),
          AdminMenuButton(),
          SizedBox(
            height: 5,
          ),
          AdminMenuButton(),
          Spacer(),
          AdminMenuButton(),
        ],
      ),
    );
  }
}
