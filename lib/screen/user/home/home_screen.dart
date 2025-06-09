import 'package:alien_quiz/screen/user/history/history_screen.dart';
import 'package:alien_quiz/screen/user/import/import_screen.dart';
import 'package:alien_quiz/screen/user/quiz/quiz_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  DataTable(
                    columnSpacing: 12,
                    headingRowColor: MaterialStateProperty.all(Colors.orange),
                    columns: const [
                      DataColumn(label: Text('Tingkat Kesulitan')),
                      DataColumn(label: Text('Tema Pelajaran')),
                      DataColumn(label: Text('Skor')),
                      DataColumn(label: Text('')),
                    ],
                    rows: List.generate(4, (index) {
                      return DataRow(cells: [
                        const DataCell(Text('Level 1')),
                        const DataCell(Text('Matematika')),
                        const DataCell(Text('--/--')),
                        DataCell(
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const QuizScreen()),
                            ),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            child: const Text('Mulai Quiz'),
                          ),
                        ),
                      ]);
                    }),
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
