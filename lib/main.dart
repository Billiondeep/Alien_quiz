import 'dart:convert';
import 'dart:io';

import 'package:alien_quiz/screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:alien_quiz/screen/user/welcome/home/import/import_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AlienQuizApp());
}

class AlienQuizApp extends StatefulWidget {
  const AlienQuizApp({super.key});

  @override
  State<AlienQuizApp> createState() => _AlienQuizAppState();
}

class _AlienQuizAppState extends State<AlienQuizApp> {
  Map<String, dynamic>? _sharedQuiz;
  bool _checkedIntent = false;

  @override
  void initState() {
    super.initState();
    _handleSharedIntent();
  }

  Future<void> _handleSharedIntent() async {
    try {
      final media = await ReceiveSharingIntent.instance.getInitialMedia();
      if (media.isNotEmpty) {
        final path = media.first.path;
        final content = await File(path).readAsString();
        final jsonData = jsonDecode(content);

        setState(() {
          _sharedQuiz = jsonData;
        });
      }
    } catch (e) {
      debugPrint("❌ Gagal baca shared intent: $e");
    } finally {
      setState(() => _checkedIntent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_checkedIntent) {
      // tampilkan loading sementara
      return const MaterialApp(
        home: Scaffold(
          backgroundColor: Color(0xFF1A1A2E),
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        primaryColor: Colors.orange,
      ),
      home: _sharedQuiz != null
          ? ImportScreen(sharedJson: _sharedQuiz!) // langsung buka ImportScreen
          : const WelcomeScreen(),
    );
  }
}
