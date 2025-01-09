import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/services/app_bar.dart';

import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> logout(BuildContext context) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }

    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [MyCustomAppBar()],
          ),
        ));
  }
}
