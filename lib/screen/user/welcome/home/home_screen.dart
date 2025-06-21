import 'dart:convert';
import 'package:alien_quiz/screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alien_quiz/screen/models/question_model.dart';
import 'package:alien_quiz/screen/user/welcome/home/history/history_screen.dart';
import 'package:alien_quiz/screen/user/welcome/home/import/import_screen.dart';
import 'package:alien_quiz/screen/user/welcome/home/quiz/models/dummy_quiz_list.dart';
import 'package:alien_quiz/screen/user/welcome/home/quiz/quiz_screen.dart';
import 'package:alien_quiz/screen/user/welcome/home/widgets/quiz_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<Map<String, dynamic>> importedQuizList = [];
  bool isImporting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadImportedQuiz();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  Future<void> _loadImportedQuiz() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList('imported_quiz_list') ?? [];
    setState(() {
      importedQuizList = rawList
          .map<Map<String, dynamic>>(
            (item) => jsonDecode(item) as Map<String, dynamic>,
      )
          .toList();
    });
  }

  void _startQuiz(Map<String, dynamic> quizData) {
    final List<QuestionModel> questions =
    (quizData['questions'] as List)
        .map((json) => QuestionModel.fromJson(json))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          id: quizData['id'] ?? 'quiz-imported',
          title: quizData['tema'] ?? 'Quiz',
          description: quizData['level'] ?? '',
          questions: questions,
        ),
      ),
    );
  }

  Future<void> _openImportScreen() async {
    setState(() => isImporting = true);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ImportScreen()),
    );
    if (result == true) {
      await _loadImportedQuiz();
    }
    setState(() => isImporting = false);
  }

  @override
  Widget build(BuildContext context) {
    final quizList = [
      ...dummyQuizList.map((e) => e.toJson()),
      ...importedQuizList,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF2C233D),
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text(
          "Halaman Utama",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: isImporting ? null : _openImportScreen,
            tooltip: "Import Soal Manual",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Icon(Icons.reddit, size: 80, color: Colors.white),
            const SizedBox(height: 12),
            const Text(
              "Let's Start Quizzz...",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            /// Quiz List
            Container(
              constraints: const BoxConstraints(
                maxHeight: 450,
              ),
              child: SingleChildScrollView(
                child: QuizListWidget(
                  quizList: quizList,
                  onStartQuiz: _startQuiz,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Action Buttons
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HistoryScreen(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Lihat History",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WelcomeScreen(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Keluar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
