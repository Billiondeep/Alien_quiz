import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> quizList;
  final void Function(Map<String, dynamic>) onStartQuiz;

  const QuizListWidget({
    super.key,
    required this.quizList,
    required this.onStartQuiz,
  });

  @override
  State<QuizListWidget> createState() => _QuizListWidgetState();
}

class _QuizListWidgetState extends State<QuizListWidget> {
  final Map<String, int> _scoreMap = {};

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scores = <String, int>{};

    for (var quiz in widget.quizList) {
      final id = quiz['id'];
      final score = prefs.getInt('quiz_result_$id') ?? 0;
      scores[id] = score;
    }

    setState(() {
      _scoreMap.clear();
      _scoreMap.addAll(scores);
    });
  }

  Future<void> _deleteQuiz(Map<String, dynamic> quiz) async {
    final prefs = await SharedPreferences.getInstance();
    final id = quiz['id'];

    // Hapus skor dari prefs
    await prefs.remove('quiz_result_$id');

    // Hapus dari imported_quiz_list
    final rawList = prefs.getStringList('imported_quiz_list') ?? [];
    rawList.removeWhere((item) {
      try {
        final decoded = jsonDecode(item);
        return decoded is Map && decoded['id'] == id;
      } catch (_) {
        return false;
      }
    });
    await prefs.setStringList('imported_quiz_list', rawList);

    // Update tampilan
    setState(() {
      widget.quizList.removeWhere((q) => q['id'] == id);
      _scoreMap.remove(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isScrollable = widget.quizList.length > 5;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3B324C),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'List Quiz',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            color: Colors.deepOrange,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Tingkat Kesulitan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Tema Pelajaran',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Skor',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: isScrollable ? 300 : double.infinity,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: isScrollable
                  ? const ScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              itemCount: widget.quizList.length,
              itemBuilder: (context, i) {
                final quiz = widget.quizList[i];
                final id = quiz['id'];
                final total = (quiz['questions'] as List?)?.length ?? 0;
                final score = _scoreMap[id] ?? 0;
                final displayedScore = "$score/${total * 20}";

                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 12),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              quiz['level'] ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              quiz['tema'] ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              displayedScore,
                              textAlign: TextAlign.end,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                padding:
                                const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => widget.onStartQuiz(quiz),
                              child: const Text('Mulai Quiz'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding:
                                const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Konfirmasi Hapus'),
                                    content: const Text(
                                        'Yakin ingin menghapus quiz ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Batal'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Hapus'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await _deleteQuiz(quiz);
                                }
                              },
                              child: const Text('Hapus'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
