import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/pages/admin/add_card_page.dart';
import 'package:nazorat_varaqasi/pages/admin/dashboard/dashboard.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:nazorat_varaqasi/style/app_style.dart';
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
        // floatingActionButton: FloatingActionButton(onPressed: () {}),
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Admin paneli',
            style: AppStyle.fontStyle
                .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          backgroundColor: Colors.red,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCardPage()),
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              tooltip: 'Nazorat varaqasi qo\'shish',
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () => logout(context),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              tooltip: 'Выйти',
            ),
          ],
        ),
        body: Container(
          child: DashboardPage(),
        ));
  }
}
