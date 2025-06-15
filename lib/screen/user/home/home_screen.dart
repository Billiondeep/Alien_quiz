import 'package:alien_quiz/screen/user/quiz/models/dummy_question.dart';
import 'package:alien_quiz/screen/user/quiz/models/quiz_bundle.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alien_quiz/screen/user/import/import_screen.dart';
import 'package:alien_quiz/screen/user/history/history_screen.dart';
import 'package:alien_quiz/screen/user/quiz/quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<QuizBundle> allQuizList = [dummyQuiz];
  int? quizScore;

  @override
  void initState() {
    super.initState();
    _loadQuizScore();
  }

  Future<void> _loadQuizScore() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'quiz_result_${dummyQuiz.id}';
    final storedScore = prefs.getInt(key);
    setState(() {
      quizScore = storedScore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2F),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text("Halaman Utama"),
        actions: const [Padding(padding: EdgeInsets.all(8), child: Icon(Icons.download))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.reddit, size: 60, color: Colors.white),
            const Text("Let's Start Quizzz...", style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("List Quiz", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DataTable(
                    columnSpacing: 12,
                    headingRowColor: MaterialStatePropertyAll(Colors.orange),
                    columns: const [
                      DataColumn(label: Text('Level')),
                      DataColumn(label: Text('Tema')),
                      DataColumn(label: Text('Skor')),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text(dummyQuiz.level)),
                        DataCell(Text(dummyQuiz.tema)),
                        DataCell(Text(
                          quizScore != null ? '$quizScore/${dummyQuiz.questions.length}' : '--/--',
                        )),
                        DataCell(
                          ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => QuizScreen(quiz: dummyQuiz)),
                              );
                              if (result == true) {
                                await _loadQuizScore();
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            child: const Text("Mulai Quiz"),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text("Lihat History"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ImportScreen())),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text("Import Soal"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
