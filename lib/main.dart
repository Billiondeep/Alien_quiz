import 'package:alien_quiz/screen/user/welcome/home/home_screen.dart';
import 'package:alien_quiz/screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase dengan opsi otomatis sesuai platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Init date formatting untuk lokal Indonesia
  await initializeDateFormatting('id_ID', null);

  runApp(const AlienQuizApp());
}

class AlienQuizApp extends StatelessWidget {
  const AlienQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        primaryColor: Colors.orange,
      ),
      // home: CreateQuestionFormScreen(),
      // home: HomeScreen(),
      home:WelcomeScreen()
    );
  }
}
