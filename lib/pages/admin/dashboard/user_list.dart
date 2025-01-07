// import 'package:flutter/material.dart';
// import 'package:nazorat_varaqasi/style/app_style.dart';
// import 'package:postgres/postgres.dart';
// import 'package:nazorat_varaqasi/style/app_colors.dart';

// class UserListWidget extends StatefulWidget {
//   final Function(int userId)
//       onUserSelected; // Callback для передачи выбранного пользователя

//   const UserListWidget({super.key, required this.onUserSelected});

//   @override
//   State<UserListWidget> createState() => _UserListWidgetState();
// }

// class _UserListWidgetState extends State<UserListWidget> {
//   List<Map<String, dynamic>> _usersWithTaskCounts = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadUsersWithTaskCounts();
//   }

//   Future<void> _loadUsersWithTaskCounts() async {
//     try {
//       final conn = await Connection.open(
//         Endpoint(
//           host: '10.100.9.145',
//           database: 'abdulaziz',
//           username: 'postgres',
//           password: 'fizmasoft7998872',
//         ),
//         settings: ConnectionSettings(sslMode: SslMode.disable),
//       );

//       final result = await conn.execute(
//         Sql.named(
//           'SELECT u.id, u.firstname, u.lastname, COUNT(c.id) AS task_count '
//           'FROM public.users u '
//           'LEFT JOIN public.control_cards c ON u.id = c.user_id '
//           'GROUP BY u.id, u.firstname, u.lastname '
//           'ORDER BY u.firstname ASC',
//         ),
//       );

//       setState(() {
//         _usersWithTaskCounts = result.map((row) => row.toColumnMap()).toList();
//       });

//       await conn.close();
//     } catch (e) {
//       print('Ошибка при загрузке пользователей: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Ошибка: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _usersWithTaskCounts.isEmpty
//         ? const Center(
//             child: CircularProgressIndicator(),
//           )
//         : Card(
//             color: AppColors.foregroundColor,
//             margin: const EdgeInsets.all(16.0),
//             child: ListView.builder(
//               itemCount: _usersWithTaskCounts.length,
//               itemBuilder: (context, index) {
//                 final user = _usersWithTaskCounts[index];
//                 return GestureDetector(
//                   onTap: () {
//                     widget
//                         .onUserSelected(user['id']); // Передача ID пользователя
//                   },
//                   child: ListTile(
//                     title: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.black45,
//                           borderRadius: BorderRadius.circular(10)),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 10),
//                       child: Text(
//                         '${user['firstname']} ${user['lastname']}',
//                         style: AppStyle.fontStyle.copyWith(fontSize: 15),
//                       ),
//                     ),
//                     subtitle: Text(
//                       'Задач: ${user['task_count']}',
//                       style: AppStyle.fontStyle,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//   }
// }
