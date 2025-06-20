import 'dart:convert';
import 'dart:io';

import 'package:alien_quiz/screen/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

class CreateQuestionFormScreen extends StatefulWidget {
  const CreateQuestionFormScreen({super.key});

  @override
  State<CreateQuestionFormScreen> createState() => _CreateQuestionFormScreenState();
}

class _CreateQuestionFormScreenState extends State<CreateQuestionFormScreen> {
  final TextEditingController temaController = TextEditingController();
  int level = 1;

  final List<TextEditingController> questionControllers =
  List.generate(5, (_) => TextEditingController());
  final List<List<TextEditingController>> answerControllers =
  List.generate(5, (_) => List.generate(5, (_) => TextEditingController()));
  final List<int> correctIndexes = List.generate(5, (_) => 0);

  Future<void> _exportToFile() async {
    final questions = <QuestionModel>[];

    for (int i = 0; i < 5; i++) {
      if (questionControllers[i].text.isEmpty ||
          answerControllers[i].any((ctrl) => ctrl.text.trim().isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Soal ${i + 1} belum lengkap'), backgroundColor: Colors.red),
        );
        return;
      }
      final question = questionControllers[i].text;
      final options = answerControllers[i].map((c) => c.text).toList();
      final correct = correctIndexes[i];
      questions.add(QuestionModel(
        question: question,
        options: options,
        correctAnswerIndex: correct,
      ));
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final data = {
      'id': id,
      'tema': temaController.text.trim(),
      'level': 'Level $level',
      'questions': questions.map((q) => q.toJson()).toList(),
    };

    if (Platform.isAndroid) {
      await Permission.storage.request();
    }

    final dir = await getApplicationDocumentsDirectory();
    final tema = temaController.text.trim().replaceAll(" ", "");
    final tanggal = DateFormat("dd-MMMM-yyyy", "id_ID").format(DateTime.now());
    final filename = '$tema-Level$level-$tanggal.json';
    final file = File('${dir.path}/$filename');
    await file.writeAsString(jsonEncode(data));

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("✅ Soal berhasil diekspor"),
        content: Text("File berhasil disimpan dengan nama:\n\n$filename"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await OpenFile.open(file.path);
            },
            child: const Text("Lihat File"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Share.shareXFiles([XFile(file.path)], text: 'Berikut soal yang sudah dibuat');
            },
            child: const Text("Bagikan File"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C233D),
      appBar: AppBar(title: const Text('Buat Soal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: temaController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Tema',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: level,
              onChanged: (v) => setState(() => level = v ?? 1),
              items: List.generate(5, (i) => DropdownMenuItem(
                value: i + 1,
                child: Text('Level ${i + 1}'),
              )),
              decoration: const InputDecoration(labelText: 'Tingkat Kesulitan'),
            ),
            const SizedBox(height: 24),
            for (int i = 0; i < 5; i++)
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Soal ${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextField(
                        controller: questionControllers[i],
                        decoration: const InputDecoration(labelText: 'Pertanyaan'),
                      ),
                      ...List.generate(5, (j) => TextField(
                        controller: answerControllers[i][j],
                        decoration: InputDecoration(labelText: 'Jawaban ${j + 1}'),
                      )),
                      DropdownButtonFormField<int>(
                        value: correctIndexes[i],
                        onChanged: (v) => setState(() => correctIndexes[i] = v ?? 0),
                        items: List.generate(5, (j) => DropdownMenuItem(
                          value: j,
                          child: Text('Jawaban Benar: ${j + 1}'),
                        )),
                      )
                    ],
                  ),
                ),
              ),
            Center(
              child: ElevatedButton.icon(
                onPressed: _exportToFile,
                icon: const Icon(Icons.download, color: Colors.black),
                label: const Text(
                  'Export Soal',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
