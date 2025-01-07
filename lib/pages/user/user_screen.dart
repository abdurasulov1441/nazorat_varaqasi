import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/pages/user/card_widgets.dart';
import 'package:nazorat_varaqasi/pages/user/grafik.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Timer? _timer;
  String? _userId;
  String? _userFullName;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndStartListening();
    _loadUserIdAndUserInfo();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  Future<void> _loadUserIdAndStartListening() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    if (_userId != null) {
      _startListening();
    } else {
      print("Ошибка: ID пользователя не найден.");
    }
  }

  void _startListening() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkForNewCards();
    });
  }

  Future<void> _checkForNewCards() async {
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
          'SELECT * FROM public.control_cards WHERE user_id = @user_id AND status_id = 1 ORDER BY id ASC',
        ),
        parameters: {
          'user_id': int.parse(_userId!),
        },
      );

      final newCards = result.map((row) => row.toColumnMap()).toList();

      for (final card in newCards) {
        final remainingDays = _calculateRemainingDays(card['end_date']);
        final notificationBody =
            "Nazorat varaqasi № ${(card['card_number'])}\n$remainingDays\nBoshlanish sanasi: ${_formatDate(card['start_date'])}\nTugash muddati: ${_formatDate(card['end_date'])}\nTavsif: ${card['description']}";

        await _showWindowsNotification(
          "Yangi karta №${card['card_number']}",
          notificationBody,
        );

        await conn.execute(
          Sql.named(
            'UPDATE public.control_cards SET status_id = 2 WHERE id = @id',
          ),
          parameters: {
            'id': card['id'],
          },
        );
      }

      await conn.close();
    } catch (e) {
      print('Ошибка при проверке новых карточек: $e');
    }
  }

  Future<void> _showWindowsNotification(String title, String body) async {
    final notification = NotificationMessage.fromPluginTemplate(
      title,
      body,
      '',
    );

    final windowsNotification = WindowsNotification(
      applicationId: r'Nazorat varaqasi',
    );

    await windowsNotification.showNotificationPluginTemplate(notification);
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
          ? "$difference kun qoldi"
          : difference == 0
              ? "Bugun"
              : "Muddati o'tgan";
    } else if (date is String) {
      return _calculateRemainingDays(DateTime.parse(date));
    } else if (date is List) {
      List<DateTime> dates =
          date.map((d) => DateTime.parse(d.toString())).toList();
      dates.sort();
      return dates.isNotEmpty
          ? _calculateRemainingDays(dates.first)
          : "Noma'lum muddat";
    }
    return "Noma'lum muddat";
  }

  Future<void> _loadUserIdAndUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    if (_userId != null) {
      await _fetchUserFullName();
      _startListening();
    } else {
      print("Ошибка: ID пользователя не найден.");
    }
  }

  Future<void> _fetchUserFullName() async {
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
          'SELECT firstname, lastname FROM public.users WHERE id = @id',
        ),
        parameters: {
          'id': int.parse(_userId!),
        },
      );

      if (result.isNotEmpty) {
        final row = result.first.toColumnMap();
        setState(() {
          _userFullName = "${row['firstname']} ${row['lastname']}";
        });
      }

      await conn.close();
    } catch (e) {
      print('Ошибка при загрузке имени и фамилии пользователя: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
          ),
        ],
        title: Text(_userFullName ?? 'Загрузка...'),
        backgroundColor: Colors.green,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(
            width: 300,
            child: GraphWidget(),
          ),
          Expanded(
            flex: 1,
            child: CardsWidget(),
          ),
        ],
      ),
    );
  }
}
