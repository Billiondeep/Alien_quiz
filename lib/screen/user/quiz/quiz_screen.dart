import 'dart:async';
import 'package:alien_quiz/screen/user/quiz/models/question_model.dart';
import 'package:alien_quiz/screen/user/quiz/models/quiz_bundle.dart';
import 'package:flutter/material.dart';
import 'package:alien_quiz/screen/user/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatefulWidget {
  final QuizBundle quiz;

  const QuizScreen({super.key, required this.quiz});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<QuestionModel> questions;
  late List<int?> selectedAnswers;
  int currentQuestion = 0;
  int score = 0;

  Timer? countdownTimer;
  Duration remainingTime = const Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    questions = widget.quiz.questions;
    selectedAnswers = List.filled(questions.length, null);
    _startTimer();
    print("Initialized quiz with ${questions.length} questions");
  }

  void _startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds <= 1) {
        timer.cancel();
        _timeout();
      } else {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
        });
      }
    });
  }

  void _timeout() {
    print("Timeout reached");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
    );
  }

  void _nextQuestion() {
    print("Next tapped, currentQuestion: $currentQuestion");
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      countdownTimer?.cancel();
      _showResult();
    }
  }

  void _prevQuestion() {
    if (currentQuestion > 0) {
      setState(() {
        currentQuestion--;
      });
    }
  }

  int _calculateScore() {
    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctAnswerIndex) {
        correct++;
      }
    }
    return correct;
  }

  Future<void> _saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("quiz_result_${widget.quiz.id}", score);
    print("Score saved: $score");
  }

  void _showResult() async {
    score = _calculateScore();
    print("Quiz selesai. Score: $score / ${questions.length}");
    await _saveScore();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.quiz.tema,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(widget.quiz.level,
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _formatDuration(remainingTime),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Kartu soal
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "QUESTION ${currentQuestion + 1} / ${questions.length}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Text(question.question, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    const Text("Pilih satu jawaban:", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    Column(
                      children: List.generate(question.options.length, (index) {
                        return ListTile(
                          title: Text(question.options[index]),
                          leading: Radio<int>(
                            value: index,
                            groupValue: selectedAnswers[currentQuestion],
                            onChanged: (value) {
                              setState(() {
                                selectedAnswers[currentQuestion] = value;
                                print("Jawaban untuk Q$currentQuestion diset ke $value");
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tombol PREV dan NEXT / SELESAI
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: currentQuestion > 0 ? _prevQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("PREV", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    onPressed: selectedAnswers[currentQuestion] == null ? null : _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      currentQuestion == questions.length - 1 ? "SELESAI" : "NEXT",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}