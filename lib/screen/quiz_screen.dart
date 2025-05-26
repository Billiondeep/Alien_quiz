import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text("03:50", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("QUESTION 01/05", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                        "Fitur yang memungkinkan developer melihat perubahan UI secara real-time tanpa restart aplikasi di Flutter disebut:"),
                    const SizedBox(height: 8),
                    const Text("Select Only One!", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Column(
                      children: const [
                        ListTile(title: Text("Cool Refresh"), leading: Radio(value: 0, groupValue: null, onChanged: null)),
                        ListTile(title: Text("Hot Reload"), leading: Radio(value: 1, groupValue: null, onChanged: null)),
                        ListTile(title: Text("Warm Restart"), leading: Radio(value: 2, groupValue: null, onChanged: null)),
                        ListTile(title: Text("Live Update"), leading: Radio(value: 3, groupValue: null, onChanged: null)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text("NEXT"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
