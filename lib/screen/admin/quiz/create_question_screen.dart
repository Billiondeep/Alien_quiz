import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:alien_quiz/screen/admin/widgets/admin_header.dart';
import 'widgets/form_pg_widget.dart';
import './models/question_model.dart';
import 'widgets/difficulty_dropdown.dart';

class QuestionFormScreen extends StatefulWidget {
  const QuestionFormScreen({super.key});

  @override
  State<QuestionFormScreen> createState() => _QuestionFormScreenState();
}

class _QuestionFormScreenState extends State<QuestionFormScreen> {
  final TextEditingController _temaController = TextEditingController();
  String _difficulty = 'Level 1';
  List<QuestionModel> _questions = List.generate(5, (_) => QuestionModel());

  Future<void> exportToJson() async {
    if (_temaController.text.trim().isEmpty) {
      return _showError("Tema tidak boleh kosong");
    }

    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      if (q.question.trim().isEmpty ||
          q.options.any((opt) => opt.trim().isEmpty)) {
        return _showError(
          "Semua soal dan jawaban harus diisi (Cek Soal ${i + 1})",
        );
      }
    }

    final data = {
      "tema": _temaController.text.trim(),
      "level": _difficulty,
      "questions": _questions.map((q) => q.toJson()).toList(),
    };

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/soal.json');
    await file.writeAsString(jsonEncode(data));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Soal berhasil diekspor ke soal.json')),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.amber),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C233D),
      body: SafeArea(
        child: Column(
          children: [
            AdminHeader(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: [
                    // Title
                    Center(
                      child: Text(
                        "📝 Membuat Soal Pilihan Ganda",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Input Tema
                    Text(
                      "Tema",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _temaController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("Masukan Tema"),
                    ),

                    const SizedBox(height: 20),

                    DifficultyDropdown(
                        selectedLevel: _difficulty,
                        onChanged: (value) => setState(() => _difficulty = value),
                      ),

                    const SizedBox(height: 28),

                    // Form untuk 5 Soal
                    ...List.generate(
                      _questions.length,
                      (i) => SoalFormWidget(
                        index: i,
                        model: _questions[i],
                        onChanged: (updatedModel) {
                          setState(() => _questions[i] = updatedModel);
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Tombol Export
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: exportToJson,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: const Icon(Icons.download, color: Colors.black),
                        label: const Text(
                          "Export Soal",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
