import 'dart:async';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? _userId;
  List<Map<String, dynamic>> _userCards = [];
  int totalCards = 0;
  int activeCards = 0;
  int completedCards = 0;
  Timer? _pollingTimer;
  Timer? _hourlyNotificationTimer;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _startPolling();
    _startHourlyNotifications();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _hourlyNotificationTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString('userId');

    if (savedUserId == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    setState(() {
      _userId = savedUserId;
    });

    _fetchUserCards();
  }

  Future<void> _fetchUserCards() async {
    if (_userId == null) return;

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
        Sql.named('SELECT * FROM public.control_cards WHERE user_id=@user_id'),
        parameters: {'user_id': int.parse(_userId!)},
      );

      final allCards = result.map((row) => row.toColumnMap()).toList();

      for (final card in allCards.where((card) => card['status_id'] == 1)) {
        _showNotification(card);
        await _markAsRead(card['id']);
      }

      setState(() {
        _userCards = allCards;
        totalCards = allCards.length;
        activeCards = allCards
            .where((card) => card['status_id'] == 1 || card['status_id'] == 2)
            .length;
        completedCards =
            allCards.where((card) => card['status_id'] == 3).length;
      });

      await conn.close();
    } catch (e) {
      print('Ошибка при получении данных пользователя: $e');
    }
  }

  Future<void> _markAsRead(int cardId) async {
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
          'UPDATE public.control_cards SET status_id = 2 WHERE id=@card_id',
        ),
        parameters: {'card_id': cardId},
      );

      await conn.close();
    } catch (e) {
      print('Ошибка при обновлении статуса: $e');
    }
  }

  void _showNotification(Map<String, dynamic> card) {
    final message = NotificationMessage.fromPluginTemplate(
      "Control Card Notification",
      "Новая карточка: ${card['card_number']}",
      '''
Описание: ${card['description']}
Дата окончания: ${_getNextEndDate(card['end_date'])}
Уровень задачи: ${card['task_level_id'] ?? 'Не указан'}
''',
      payload: {
        "action": "open_card",
        "card_id": card['id'],
      },
    );

    WindowsNotification(applicationId: r"{YourAppID}")
        .showNotificationPluginTemplate(message);
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchUserCards();
    });
  }

  void _startHourlyNotifications() {
    _hourlyNotificationTimer =
        Timer.periodic(const Duration(hours: 1), (timer) {
      for (final card in _userCards) {
        _showNotification(card);
      }
    });
  }

  String _getNextEndDate(dynamic endDates) {
    if (endDates is String) {
      // Если только одна дата, вернуть её
      return _formatDate(DateTime.parse(endDates));
    } else if (endDates is List) {
      // Если список дат, найти ближайшую
      List<DateTime> dates = endDates
          .map((date) => DateTime.parse(date.toString()))
          .where((date) => date.isAfter(DateTime.now()))
          .toList();
      dates.sort();
      if (dates.isNotEmpty) {
        return _formatDate(dates.first);
      }
    }
    return "Не указано";
  }

// Форматирование даты
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Панель пользователя'),
        backgroundColor: Colors.green,
      ),
      body: Row(
        children: [
          SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Статистика задач',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: totalCards.toDouble(),
                                title: 'Всего: $totalCards',
                                color: Colors.blue,
                              ),
                              PieChartSectionData(
                                value: activeCards.toDouble(),
                                title: 'Активные: $activeCards',
                                color: Colors.orange,
                              ),
                              PieChartSectionData(
                                value: completedCards.toDouble(),
                                title: 'Завершенные: $completedCards',
                                color: Colors.green,
                              ),
                            ],
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _userCards.isEmpty
                ? const Center(
                    child: Text(
                      'Нет данных для отображения.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: _userCards.length,
                    itemBuilder: (context, index) {
                      final card = _userCards[index];
                      final cardColor = card['task_level_id'] == 1
                          ? Colors.red[100]
                          : Colors.white;
                      return Card(
                        color: cardColor,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Карточка: ${card['card_number']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Описание: ${card['description']}'),
                              Text(
                                'Дата окончания: ${_getNextEndDate(card['end_date'])}',
                              ),
                              Text(
                                'Уровень задачи: ${card['task_level_id'] ?? 'Не указан'}',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
