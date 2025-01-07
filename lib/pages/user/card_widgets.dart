import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:nazorat_varaqasi/style/app_style.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardsWidget extends StatefulWidget {
  const CardsWidget({super.key});

  @override
  State<CardsWidget> createState() => _CardsWidgetState();
}

class _CardsWidgetState extends State<CardsWidget> {
  List<Map<String, dynamic>> _userCards = [];
  Timer? _timer;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndStartPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadUserIdAndStartPolling() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    if (_userId != null) {
      _startPolling();
    } else {
      print("Ошибка: ID пользователя не найден.");
    }
  }

  void _startPolling() {
    _fetchCardsData();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchCardsData();
    });
  }

  Future<void> _fetchCardsData() async {
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
          'SELECT * FROM public.control_cards WHERE user_id = @user_id AND status_id != 3 ORDER BY id ASC',
        ),
        parameters: {
          'user_id': int.parse(_userId!),
        },
      );

      final cards = result.map((row) => row.toColumnMap()).toList();

      setState(() {
        _userCards = cards;
      });

      await conn.close();
    } catch (e) {
      print('Ошибка при загрузке карточек: $e');
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

  @override
  Widget build(BuildContext context) {
    return _userCards.isEmpty
        ? const Center(
            child: Text(
              'Нет данных для отображения.',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _userCards.map((card) {
                  final isOverdue = card['status_id'] == 4;
                  final isNearDeadline = card['status_id'] == 5;
                  return Container(
                    width: 450,
                    decoration: BoxDecoration(
                      color: AppColors.foregroundColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: isOverdue
                                      ? const Color.fromARGB(255, 248, 79, 96)
                                      : isNearDeadline
                                          ? const Color.fromARGB(
                                              255, 252, 194, 107)
                                          : const Color.fromARGB(
                                              255, 134, 207, 136),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                'Nazorat varaqasi №${card['card_number']}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            if (card['task_level_id'] == 1)
                              Text(
                                'QBB',
                                style: AppStyle.fontStyle.copyWith(),
                              ),
                            if (card['task_level_id'] == 2)
                              Text(
                                'MG',
                                style: AppStyle.fontStyle.copyWith(),
                              ),
                            if (card['task_level_id'] == 3)
                              Text(
                                'DXX',
                                style: AppStyle.fontStyle.copyWith(),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Boshlanish sanasi: ${_formatDate(card['start_date'])}',
                          style: AppStyle.fontStyle.copyWith(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (card['end_date'] != null)
                          Text(
                            'Tugash muddati: ${_formatDate(card['end_date'])}',
                            style: AppStyle.fontStyle.copyWith(),
                          ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tavsif: ${card['description']}',
                              style: AppStyle.fontStyle.copyWith(),
                            ),
                            CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 93, 204, 255),
                              radius: 20,
                              child: Text(
                                '${_calculateRemainingDays(card['end_date'])}',
                                style: AppStyle.fontStyle,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
  }
}
