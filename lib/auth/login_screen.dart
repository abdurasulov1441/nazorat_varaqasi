import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:nazorat_varaqasi/style/app_style.dart';
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
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');

    if (savedUsername != null && savedPassword != null) {
      _autoLogin(savedUsername, savedPassword);
    }
  }

  /// Автоматический вход
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
          'SELECT id, username FROM public.users WHERE username=@username AND password=@password',
        ),
        parameters: {
          'username': username,
          'password': password,
        },
      );

      if (result.isNotEmpty) {
        final userId = result.first.toColumnMap()['id'].toString();
        final fetchedUsername = result.first.toColumnMap()['username'];

        // Сохраняем данные в `SharedPreferences`, если успешно
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setString('username', fetchedUsername);
        await prefs.setString('password', password);

        print('Автологин успешен: ID пользователя - $userId');
        Navigator.pushNamed(context, '/home');
      } else {
        print('Неверные данные при автологине.');
      }

      await conn.close();
    } catch (e) {
      print('Ошибка автологина: $e');
    }
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

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
        final password = passwordController.text.trim();

        print('Логин успешен! ID пользователя: $userId');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setString('username', username);
        await prefs.setString('password', password);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Успешный вход!'),
            backgroundColor: Colors.green,
          ),
        );

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
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
          child: Form(
            key: formKey,
            child: Column(
              children: [
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
                Center(
                  child: Text('Xush kelibsiz!',
                      style: AppStyle.fontStyle
                          .copyWith(fontSize: 28, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text('Tizimga kirishingiz mumkin',
                      style: AppStyle.fontStyle),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 400,
                  height: 400,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hoverColor: AppColors.hoverColor,
                          filled: true,
                          fillColor: AppColors.foregroundColor,
                          hintText: 'Login',
                          hintStyle: AppStyle.fontStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Loginni kiriting';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: isHiddenPassword,
                        decoration: InputDecoration(
                          hoverColor: AppColors.hoverColor,
                          filled: true,
                          fillColor: AppColors.foregroundColor,
                          hintText: 'Parol',
                          hintStyle: AppStyle.fontStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isHiddenPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.iconColor,
                            ),
                            onPressed: togglePasswordView,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Parolni kiriting';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.iconColor,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Kirish',
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
