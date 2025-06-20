import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? importedQuiz;

  StreamSubscription? _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    _loadImportedQuiz();

    // ✅ Panggil dari instance, tidak perlu membuat objek langsung
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      if (value.isNotEmpty) {
        final path = value.first.path;
        debugPrint("📦 Diterima saat awal: $path");
        _loadSharedFile(path);
      }
    });

    _intentDataStreamSubscription =
        ReceiveSharingIntent.instance.getMediaStream().listen((value) {
          if (value.isNotEmpty) {
            final path = value.first.path;
            debugPrint("📥 Diterima saat berjalan: $path");
            _loadSharedFile(path);
          }
        });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadSharedFile(String path) async {
    try {
      final file = File(path);
      final content = await file.readAsString();
      final json = jsonDecode(content);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('imported_quiz', jsonEncode(json));

      if (!mounted) return;

      setState(() {
        importedQuiz = json;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Soal berhasil diimpor dari file")),
      );

      _startQuiz(json);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Gagal load file: $e")),
        );
      }
    }
  }

  Future<void> _loadImportedQuiz() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('imported_quiz');
    if (raw != null) {
      final data = jsonDecode(raw);
      setState(() {
        importedQuiz = data;
      });
    }
  }

  void _startQuiz(Map<String, dynamic> quizData) {
    final List<QuestionModel> questions = (quizData['questions'] as List)
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
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ImportScreen()),
    );
    if (result == true) {
      await _loadImportedQuiz();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quizList = [
      ...dummyQuizList.map((e) => e.toJson()),
      if (importedQuiz != null) importedQuiz!,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF2C233D),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Halaman Utama"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _openImportScreen,
            tooltip: "Import Soal",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Icon(Icons.emoji_emotions, size: 80, color: Colors.white),
            const SizedBox(height: 12),
            const Text(
              "Let's Start Quizzz...",
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            QuizListWidget(
              quizList: quizList,
              onStartQuiz: _startQuiz,
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("Lihat History", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("Keluar"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
