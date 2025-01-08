import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:nazorat_varaqasi/style/app_style.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> _usersWithTaskCounts = [];
  List<Map<String, dynamic>> _userTasks = [];
  int? _selectedUserId;
  String _filterStatus = "inProgress";

  @override
  void initState() {
    super.initState();
    _loadUsersWithTaskCounts();
  }

  Future<void> _loadUsersWithTaskCounts() async {
    try {
      final conn = await Connection.open(
        Endpoint(
          host: '10.100.9.145',
          database: 'abdulaziz',
          username: 'postgres',
          password: 'fizmasoft7998872',
        ),
        settings: ConnectionSettings(sslMode: SslMode.disable),
      );

      final result = await conn.execute(
        Sql.named(
          'SELECT u.id, u.firstname, u.lastname, COUNT(c.id) AS task_count '
          'FROM public.users u '
          'LEFT JOIN public.control_cards c ON u.id = c.user_id '
          'GROUP BY u.id, u.firstname, u.lastname '
          'ORDER BY u.firstname ASC',
        ),
      );

      setState(() {
        _usersWithTaskCounts = result.map((row) => row.toColumnMap()).toList();
      });

      await conn.close();
    } catch (e) {
      print('Ошибка при загрузке пользователей: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadUserTasks(int userId) async {
    try {
      final conn = await Connection.open(
        Endpoint(
          host: '10.100.9.145',
          database: 'abdulaziz',
          username: 'postgres',
          password: 'fizmasoft7998872',
        ),
        settings: ConnectionSettings(sslMode: SslMode.disable),
      );

      final result = await conn.execute(
        Sql.named(
          'SELECT * FROM public.control_cards WHERE user_id = @user_id ORDER BY id ASC',
        ),
        parameters: {
          'user_id': userId,
        },
      );

      setState(() {
        _userTasks = result.map((row) => row.toColumnMap()).toList();
        _selectedUserId = userId;
      });

      await conn.close();
    } catch (e) {
      print('Ошибка при загрузке задач пользователя: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateTaskStatus(int taskId) async {
    try {
      final conn = await Connection.open(
        Endpoint(
          host: '10.100.9.145',
          database: 'abdulaziz',
          username: 'postgres',
          password: 'fizmasoft7998872',
        ),
        settings: ConnectionSettings(sslMode: SslMode.disable),
      );

      await conn.execute(
        Sql.named(
          'UPDATE public.control_cards SET status_id = 3 WHERE id = @task_id',
        ),
        parameters: {
          'task_id': taskId,
        },
      );

      // После обновления, перезагрузим список задач
      if (_selectedUserId != null) {
        await _loadUserTasks(_selectedUserId!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Карточка успешно завершена!'),
          backgroundColor: Colors.green,
        ),
      );

      await conn.close();
    } catch (e) {
      print('Ошибка обновления статуса карточки: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(dynamic date) {
    if (date is DateTime) {
      return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
    } else if (date is String) {
      return _formatDate(DateTime.parse(date));
    } else if (date is List) {
      List<DateTime> dates =
          date.map((d) => DateTime.parse(d.toString())).toList();
      dates.sort();
      return dates.isNotEmpty
          ? "${dates.first.day.toString().padLeft(2, '0')}.${dates.first.month.toString().padLeft(2, '0')}.${dates.first.year}"
          : "Noma'lum sana";
    }
    return "Noma'lum sana";
  }

  String _calculateRemainingDays(dynamic date) {
    if (date is DateTime) {
      final now = DateTime.now();
      final difference = date.difference(now).inDays;
      return difference > 0
          ? "$difference"
          : difference == 0
              ? "1"
              : "0";
    } else if (date is String) {
      return _calculateRemainingDays(DateTime.parse(date));
    } else if (date is List) {
      List<DateTime> dates =
          date.map((d) => DateTime.parse(d.toString())).toList();
      dates.sort();
      return dates.isNotEmpty ? _calculateRemainingDays(dates.first) : "0";
    }
    return "0";
  }

  List<Map<String, dynamic>> _getFilteredTasks() {
    if (_filterStatus == "inProgress") {
      return _userTasks
          .where((task) => task['status_id'] != 3)
          .toList(); // Исключить статус 3
    } else if (_filterStatus == "completed") {
      return _userTasks
          .where((task) => task['status_id'] == 3)
          .toList(); // Только статус 3
    }
    return _userTasks;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _getFilteredTasks();
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  color: AppColors.foregroundColor,
                  margin: const EdgeInsets.all(16.0),
                  child: _usersWithTaskCounts.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: _usersWithTaskCounts.length,
                          itemBuilder: (context, index) {
                            final user = _usersWithTaskCounts[index];
                            return GestureDetector(
                              onTap: () => _loadUserTasks(user['id']),
                              child: ListTile(
                                title: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 10),
                                  child: Text(
                                    '${user['firstname']} ${user['lastname']}',
                                    style: AppStyle.fontStyle
                                        .copyWith(fontSize: 15),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Card(
                  color: AppColors.foregroundColor,
                  margin: const EdgeInsets.all(16.0),
                  child: _selectedUserId == null
                      ? const Center(
                          child: Text(
                            'Выберите пользователя, чтобы увидеть его задачи.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : filteredTasks.isEmpty
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          backgroundColor:
                                              _filterStatus == "inProgress"
                                                  ? Colors.blue
                                                  : AppColors.backgroundColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _filterStatus = "inProgress";
                                          });
                                        },
                                        child: const Text(
                                          "Jarayonda",
                                          style: AppStyle.fontStyle,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          backgroundColor:
                                              _filterStatus == "completed"
                                                  ? Colors.blue
                                                  : AppColors.backgroundColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _filterStatus = "completed";
                                          });
                                        },
                                        child: const Text(
                                          "Yakunlangan",
                                          style: AppStyle.fontStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    'У выбранного пользователя нет задач.',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          backgroundColor:
                                              _filterStatus == "inProgress"
                                                  ? Colors.blue
                                                  : AppColors.backgroundColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _filterStatus = "inProgress";
                                          });
                                        },
                                        child: const Text(
                                          "Jarayonda",
                                          style: AppStyle.fontStyle,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          backgroundColor:
                                              _filterStatus == "completed"
                                                  ? Colors.blue
                                                  : AppColors.backgroundColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _filterStatus = "completed";
                                          });
                                        },
                                        child: const Text(
                                          "Yakunlangan",
                                          style: AppStyle.fontStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: filteredTasks.map((task) {
                                    final isOverdue = task['status_id'] == 4;
                                    final isNearDeadline =
                                        task['status_id'] == 5;
                                    return Container(
                                      width: 450,
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundColor,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: isOverdue
                                                      ? Colors.red
                                                      : isNearDeadline
                                                          ? Colors.orange
                                                          : Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  'Nazorat varaqasi №${task['card_number']}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              if (task['task_level_id'] == 1)
                                                Text(
                                                  'QBB',
                                                  style: AppStyle.fontStyle
                                                      .copyWith(),
                                                ),
                                              if (task['task_level_id'] == 2)
                                                Text(
                                                  'MG',
                                                  style: AppStyle.fontStyle
                                                      .copyWith(),
                                                ),
                                              if (task['task_level_id'] == 3)
                                                Text(
                                                  'DXX',
                                                  style: AppStyle.fontStyle
                                                      .copyWith(),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Boshlanish sanasi: ${_formatDate(task['start_date'])}',
                                            style:
                                                AppStyle.fontStyle.copyWith(),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Tugash muddati: ${_formatDate(task['end_date'])}',
                                                style: AppStyle.fontStyle
                                                    .copyWith(),
                                              ),
                                              CircleAvatar(
                                                radius: 15,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 93, 204, 255),
                                                child: Text(
                                                  _calculateRemainingDays(
                                                      task['end_date']),
                                                  style: AppStyle.fontStyle,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Tavsif: ${task['description']}',
                                                style: AppStyle.fontStyle
                                                    .copyWith(),
                                              ),
                                              if (task['status_id'] != 3)
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            AppColors
                                                                .foregroundColor,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10))),
                                                    onPressed: () {
                                                      _updateTaskStatus(
                                                          task['id']);
                                                    },
                                                    child: Text(
                                                      'Yakunlash',
                                                      style: AppStyle.fontStyle,
                                                    ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
