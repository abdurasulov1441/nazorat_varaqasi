import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/pages/admin/admin_dashboard/admin_page.dart';
import 'package:nazorat_varaqasi/pages/user/user_screen.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    try {
      // Получение имени пользователя из SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');

      if (username == null) {
        throw Exception('Имя пользователя не найдено в памяти устройства');
      }

      // Подключение к базе данных
      final conn = await Connection.open(
        Endpoint(
          host: '10.100.9.145', // Ваш IP-адрес
          database: 'abdulaziz', // Имя базы данных
          username: 'postgres', // Имя пользователя
          password: 'fizmasoft7998872', // Пароль
        ),
        settings: ConnectionSettings(sslMode: SslMode.disable),
      );

      // Запрос роли пользователя
      final result = await conn.execute(
        Sql.named(
          'SELECT role_id FROM public.users WHERE username=@username',
        ),
        parameters: {
          'username': username,
        },
      );

      await conn.close();

      if (result.isNotEmpty) {
        final roleId = result.first.toColumnMap()['role_id'] as int?;

        if (roleId == 1) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminScreen()),
            (route) => false,
          );
        } else if (roleId == 2) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const UserScreen()),
            (route) => false,
          );
        } else {
          throw Exception('Неизвестная роль: $roleId');
        }
      } else {
        throw Exception('Пользователь не найден');
      }
    } catch (e) {
      print('Ошибка при загрузке роли: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const Center(
              child: Text(
                'Ошибка загрузки или пользователь не найден.',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
    );
  }
}
