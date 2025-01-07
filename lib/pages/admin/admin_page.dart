import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/pages/admin/add_card_page.dart';
import 'package:nazorat_varaqasi/pages/admin/dashboard/dashboard.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('Админская панель'),
          backgroundColor: Colors.red,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCardPage()),
                );
              },
              icon: const Icon(Icons.add),
              tooltip: 'Добавить карточку',
            ),
          ],
        ),
        body: Container(
          child: DashboardPage(),
        ));
  }
}
