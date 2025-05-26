import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2F),
      appBar: AppBar(backgroundColor: Colors.grey[900]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("History Quiz", style: TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.orange,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text("Tema: Informatika\nLevel: 3\nScore: 85",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Kembali"),
            )
          ],
        ),
      ),
    );
  }
}
