import 'package:alien_quiz/screen/admin/quiz/question_form_screen.dart';
import 'package:alien_quiz/screen/user/quiz/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';  // import file yang di-generate flutterfire
import 'screen/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase dengan opsi otomatis sesuai platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      home: const QuestionFormScreen(),
    );
  }
}
