import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';

class UserListWidget extends StatelessWidget {
  const UserListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {'firstname': 'Ворис', 'lastname': 'Рахимов', 'tasks': 10},
      {'firstname': 'Абдулазиз', 'lastname': 'Абдурасулов', 'tasks': 8},
      {'firstname': 'Камолиддин', 'lastname': 'Омонов', 'tasks': 5},
    ];

    return Card(
      color: AppColors.foregroundColor,
      margin: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text('${user['firstname']} ${user['lastname']}'),
            subtitle: Text('Задач: ${user['tasks']}'),
          );
        },
      ),
    );
  }
}
