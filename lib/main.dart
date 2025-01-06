import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:nazorat_varaqasi/auth/home_screen.dart';
import 'package:nazorat_varaqasi/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());

  // Устанавливаем минимальный и максимальный размер окна
  doWhenWindowReady(() {
    const initialSize = Size(1366, 768); // Фиксированный размер окна
    appWindow.minSize = initialSize; // Устанавливаем минимальный размер окна
    appWindow.maxSize = initialSize; // Устанавливаем максимальный размер окна
    appWindow.size = initialSize; // Устанавливаем стартовый размер окна
    appWindow.alignment = Alignment.center; // Центрируем окно
    appWindow.title = "My Fixed Size App"; // Название окна
    appWindow.show(); // Показываем окно
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
      initialRoute: '/',
    );
  }
}
