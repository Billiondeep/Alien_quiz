import 'package:alien_quiz/screen/admin/quiz/create_question_form_screen.dart';
import 'package:alien_quiz/screen/admin/widgets/admin_header.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C233D),
      body: SafeArea(
        child: Column(
          children: [
            AdminHeader(
              icon: Icons.logout,
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            const Spacer(),

            // Card Buat Soal
            Center(
              child: Container(
                width: 300,
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 6,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Icon Reddit di pojok kanan atas
                    const Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(Icons.reddit, color: Colors.white, size: 32),
                    ),

                    // Tombol Buat Soal di tengah
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CreateQuestionFormScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          child: Text(
                            'Buat Soal',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
