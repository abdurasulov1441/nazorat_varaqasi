import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphWidget extends StatefulWidget {
  const GraphWidget({super.key});

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  int activeCards = 0; // Статус 1 и 2
  int completedCards = 0; // Статус 3
  int overdueCards = 0; // Статус 4
  int nearDeadlineCards = 0; // Статус 5
  Timer? _timer;

  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    if (_userId != null) {
      _startPolling();
    } else {
      print("Ошибка: ID пользователя не найден.");
    }
  }

  void _startPolling() {
    _fetchGraphData();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchGraphData();
    });
  }

  Future<void> _fetchGraphData() async {
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
        Sql.named(
          '''
          SELECT 
            status_id, COUNT(*) AS count
          FROM public.control_cards
          WHERE user_id = @user_id
          GROUP BY status_id
          ''',
        ),
        parameters: {'user_id': int.parse(_userId!)},
      );

      final data = result.map((row) => row.toColumnMap()).toList();

      setState(() {
        activeCards = data
            .where((row) => row['status_id'] == 1 || row['status_id'] == 2)
            .fold(0, (sum, row) => sum + int.parse(row['count'].toString()));

        completedCards = data
            .where((row) => row['status_id'] == 3)
            .fold(0, (sum, row) => sum + int.parse(row['count'].toString()));

        overdueCards = data
            .where((row) => row['status_id'] == 4)
            .fold(0, (sum, row) => sum + int.parse(row['count'].toString()));

        nearDeadlineCards = data
            .where((row) => row['status_id'] == 5)
            .fold(0, (sum, row) => sum + int.parse(row['count'].toString()));
      });

      await conn.close();
    } catch (e) {
      print('Ошибка при загрузке данных для графика: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalCards =
        activeCards + completedCards + overdueCards + nearDeadlineCards;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: AppColors.foregroundColor,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: const [
                    Text(
                      'Nazorat varaqasi',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'STATISTIKASI',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 150,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: activeCards.toDouble(),
                        title: '$activeCards',
                        titleStyle:
                            TextStyle(color: Colors.white, fontSize: 20),
                        color: Colors.orange,
                      ),
                      PieChartSectionData(
                        value: completedCards.toDouble(),
                        title: '$completedCards',
                        color: Colors.green,
                        titleStyle:
                            TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      PieChartSectionData(
                        value: overdueCards.toDouble(),
                        title: '$overdueCards',
                        color: Colors.red,
                        titleStyle:
                            TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      PieChartSectionData(
                        value: nearDeadlineCards.toDouble(),
                        title: '$nearDeadlineCards',
                        color: Colors.yellow,
                        titleStyle:
                            TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Faol: $activeCards",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Tugatilgan: $completedCards",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Muddati o'tgan: $overdueCards",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.yellow,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Muddati yaqin: $nearDeadlineCards",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Jami: $totalCards",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
