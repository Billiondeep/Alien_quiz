import 'package:flutter/material.dart';
import 'question_form_screen.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C233D),
      body: Column(
        children: [
          // Header Bar dengan Icon Logout
          Container(
            color: Colors.grey[800],
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                // TODO: Tambahkan fungsi logout di sini
              },
            ),
          ),

          const Spacer(),

          // Tombol Buat Soal
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(2, 4),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.android, color: Colors.white),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuestionFormScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      'Buat Soal',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
