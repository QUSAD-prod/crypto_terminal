import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:terminal/firebase_options.dart';
import 'package:terminal/pages/history_page.dart';
import 'package:terminal/pages/home_page.dart';
import 'package:terminal/pages/main_page.dart';
import 'package:terminal/pages/pay_1_page.dart';
import 'package:terminal/pages/pay_2_page.dart';
import 'package:terminal/pages/success_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        splashFactory: InkRipple.splashFactory,
        scaffoldBackgroundColor: const Color(0xFFD8E6F0),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/main': (context) => const MainPage(),
        '/history': (context) => const HistoryPage(),
        '/pay1': (context) => const Pay1Page(),
        '/pay2': (context) => const Pay2Page(),
        '/success': (context) => const SuccessPage(),
      },
    );
  }
}
