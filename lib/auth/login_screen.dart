import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHiddenPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Загрузка сохранённых логина и пароля
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');

    if (savedUsername != null && savedPassword != null) {
      emailController.text = savedUsername;
      passwordController.text = savedPassword;
      _autoLogin(savedUsername, savedPassword);
    }
  }

  // Автоматический вход
  Future<void> _autoLogin(String username, String password) async {
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
          'SELECT * FROM public.users WHERE username=@username AND password=@password',
        ),
        parameters: {
          'username': username,
          'password': password,
        },
      );

      if (result.isNotEmpty) {
        print('Автоматический вход успешен!');
        Navigator.pushNamed(context, '/home');
      } else {
        print('Неверные учётные данные при автологине.');
      }

      await conn.close();
    } catch (e) {
      print('Ошибка автологина: $e');
    }
  }

  // Переключение видимости пароля
  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  // Метод входа
  Future<void> login() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

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
          'SELECT id, username FROM public.users WHERE username=@username AND password=@password',
        ),
        parameters: {
          'username': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      if (result.isNotEmpty) {
        final userId = result.first.toColumnMap()['id'].toString();
        final username = result.first.toColumnMap()['username'];

        print('Логин успешен! ID пользователя: $userId');

        // Сохранение данных в SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setString('username', username);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Успешный вход!'),
            backgroundColor: Colors.green,
          ),
        );

        // Переход на следующий экран
        Navigator.pushNamed(context, '/home');
      } else {
        print('Неверные учётные данные.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Неверное имя пользователя или пароль.'),
            backgroundColor: Colors.red,
          ),
        );
      }

      await conn.close();
    } catch (e) {
      print('Ошибка подключения к базе данных: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Логотип
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Заголовок
                Center(
                  child: Text(
                    'Xush kelibsiz!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Center(
                  child: Text(
                    'Tizimga kirishingiz mumkin',
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                ),
                const SizedBox(height: 30),

                Container(
                  width: 400,
                  height: 400,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[800],
                          hintText: 'Имя пользователя',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите имя пользователя';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Поле для пароля
                      TextFormField(
                        controller: passwordController,
                        obscureText: isHiddenPassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[800],
                          hintText: 'Пароль',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isHiddenPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: togglePasswordView,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите пароль';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Кнопка входа
                      ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Войти',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
