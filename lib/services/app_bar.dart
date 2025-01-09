import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:nazorat_varaqasi/style/app_style.dart';

class MyCustomAppBar extends StatelessWidget {
  const MyCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.foregroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Image.asset(
                'assets/images/logo.png',
                width: 34,
                height: 34,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Nazorat varaqalar monitoringi',
                style: AppStyle.fontStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.iconColor),
              ),
            ],
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: Image.asset(
                  'assets/images/user.png',
                  width: 24,
                  height: 24,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Abdulaziz'),
                  Text('Abdurasulov'),
                ],
              ),
              SizedBox(
                width: 20,
              ),
            ],
          )
        ],
      ),
    );
  }
}
