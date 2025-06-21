import 'dart:convert';
import 'dart:io';

import 'package:alien_quiz/screen/admin/home/home_admin.dart';
import 'package:alien_quiz/screen/admin/quiz/widgets/form_pg_widget.dart';
import 'package:alien_quiz/screen/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/date_symbol_data_local.dart';
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

  final List<QuestionModel> models = List.generate(
    5,
        (_) => QuestionModel(question: '', options: List.filled(5, ''), correctAnswerIndex: 0),
  );

  Future<void> _exportToFile() async {
    for (int i = 0; i < models.length; i++) {
      final m = models[i];
      if (m.question.trim().isEmpty || m.options.any((opt) => opt.trim().isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Soal ${i + 1} belum lengkap'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final temaRaw = temaController.text.trim();
    final safeTema = temaRaw.isEmpty
        ? 'quiz'
        : temaRaw.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_'); // aman untuk nama file
    final data = {
      'id': id,
      'tema': temaRaw,
      'level': 'Level $level',
      'questions': models.map((q) => q.toJson()).toList(),
    };

    if (Platform.isAndroid) {
      await Permission.storage.request();
    }

    await initializeDateFormatting('id_ID', null);
    final dir = await getApplicationDocumentsDirectory();
    final tanggal = DateFormat("dd-MMMM-yyyy", "id_ID").format(DateTime.now());
    final filename = '$safeTema-Level$level-$tanggal.json';
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

              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeAdmin()),
                    (route) => false,
              );
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
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Membuat Soal', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
              dropdownColor: const Color(0xFF2C233D),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Tingkat Kesulitan',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              items: List.generate(
                5,
                    (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text('Level ${i + 1}'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            for (int i = 0; i < 5; i++)
              FormPgWidget(
                index: i,
                model: models[i],
                onChanged: (val) => setState(() => models[i] = val),
              ),
            const SizedBox(height: 12),
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
