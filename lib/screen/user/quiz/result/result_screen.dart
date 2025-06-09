// File: lib/screens/result_screen.dart
import 'package:alien_quiz/screen/user/home/home_screen.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Kuis")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Skor Anda", style: const TextStyle(fontSize: 28)),
            Text("$score / $total", style: const TextStyle(fontSize: 36, color: Colors.orange)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Kembali ke Beranda"),
            )
          ],
        ),
      ),
    );
  }
}
