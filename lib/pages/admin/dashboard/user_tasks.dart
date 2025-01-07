// import 'package:flutter/material.dart';
// import 'package:postgres/postgres.dart';

// class UserTasksWidget extends StatefulWidget {
//   final int userId;

//   const UserTasksWidget({super.key, required this.userId});

//   @override
//   State<UserTasksWidget> createState() => _UserTasksWidgetState();
// }

// class _UserTasksWidgetState extends State<UserTasksWidget> {
//   List<Map<String, dynamic>> _userTasks = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserTasks();
//   }

//   Future<void> _loadUserTasks() async {
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
//           'SELECT * FROM public.control_cards WHERE user_id = @user_id ORDER BY id ASC',
//         ),
//         parameters: {
//           'user_id': widget.userId,
//         },
//       );

//       setState(() {
//         _userTasks = result.map((row) => row.toColumnMap()).toList();
//       });

//       await conn.close();
//     } catch (e) {
//       print('Ошибка при загрузке задач пользователя: $e');
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
//     return _userTasks.isEmpty
//         ? const Center(
//             child: Text(
//               'Нет задач у пользователя.',
//               style: TextStyle(color: Colors.grey, fontSize: 16),
//             ),
//           )
//         : ListView.builder(
//             itemCount: _userTasks.length,
//             itemBuilder: (context, index) {
//               final task = _userTasks[index];
//               return Card(
//                 child: ListTile(
//                   title: Text('Карточка №${task['card_number']}'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Описание: ${task['description']}'),
//                       Text('Начало: ${task['start_date']}'),
//                       Text('Конец: ${task['end_date']}'),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//   }
// }
