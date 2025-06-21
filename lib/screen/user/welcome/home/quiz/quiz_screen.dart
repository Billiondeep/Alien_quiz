import 'dart:async';
import 'dart:convert';
import 'package:alien_quiz/screen/models/question_model.dart';
import 'package:alien_quiz/screen/user/welcome/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final List<QuestionModel> questions;

  const QuizScreen({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  List<int?> answers = [];
  int score = 0;

  Timer? countdownTimer;
  Duration remainingTime = const Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    answers = List.filled(widget.questions.length, null);
    _startTimer();
  }

  void _startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds <= 1) {
        timer.cancel();
        _timeout();
      } else {
        setState(() {
          remainingTime -= const Duration(seconds: 1);
        });
      }
    });
  }

  void _timeout() => _finishQuiz();

  void _selectAnswer(int? index) {
    setState(() {
      answers[currentQuestion] = index;
    });
  }

  void _next() {
    if (currentQuestion < widget.questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      _finishQuiz();
    }
  }

  void _prev() {
    if (currentQuestion > 0) {
      setState(() {
        currentQuestion--;
      });
    }
  }

  Future<void> _finishQuiz() async {
    countdownTimer?.cancel();

    for (var i = 0; i < widget.questions.length; i++) {
      if (answers[i] == widget.questions[i].correctAnswerIndex) {
        score++;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final totalScore = score * 20;
    await prefs.setInt('quiz_result_${widget.id}', totalScore);

    final rawHistory = prefs.getString('quiz_history');
    List<Map<String, dynamic>> history = [];
    if (rawHistory != null) {
      final List decoded = jsonDecode(rawHistory);
      history = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    final newEntry = {
      'tema': widget.title,
      'level': widget.description,
      'score': score,
    };
    history.add(newEntry);
    await prefs.setString('quiz_history', jsonEncode(history));

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
    );
  }

  String _formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestion];
    final selected = answers[currentQuestion];
    double progress = (currentQuestion + 1) / widget.questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          _formatTime(remainingTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress Bar
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation(Colors.orange),
                minHeight: 5,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 24),

              // Question Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "QUESTION ${(currentQuestion + 1).toString().padLeft(2, '0')} / ${widget.questions.length.toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF444444),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C233D),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Select Only One!",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Options
                    ...List.generate(question.options.length, (index) {
                      final isSelected = selected == index;
                      return GestureDetector(
                        onTap: () => _selectAnswer(index),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.orange
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: isSelected ? Colors.orange : Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.orange
                                        : const Color(0xFF2C233D),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Navigation Buttons
              Row(
                children: [
                  if (currentQuestion > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _prev,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text("PREV"),
                      ),
                    ),
                  if (currentQuestion > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selected != null ? _next : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        currentQuestion == widget.questions.length - 1
                            ? "SELESAI"
                            : "NEXT",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
