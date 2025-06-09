import 'dart:convert';
import 'dart:io';
import 'package:alien_quiz/screen/admin/widgets/admin_header.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'widgets/soal_form_widget.dart';


class QuestionFormScreen extends StatefulWidget {
  const QuestionFormScreen({super.key});

  @override
  State<QuestionFormScreen> createState() => _QuestionFormScreenState();
}

class _QuestionFormScreenState extends State<QuestionFormScreen> {
  final TextEditingController _temaController = TextEditingController();
  String _difficulty = 'Level 1';

  List<Map<String, dynamic>> _questions = List.generate(5, (index) => {
    "question": "",
    "options": List.filled(5, ""),
    "answer": "Jawaban 1",
  });

  Future<void> exportToJson() async {
    final data = {
      "tema": _temaController.text,
      "level": _difficulty,
      "questions": _questions,
    };

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/soal.json');
    await file.writeAsString(jsonEncode(data));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Soal berhasil diekspor ke soal.json')),
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
                    // Tema
                    Row(
                      children: [
                        const Text(
                          "Tema: ",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _temaController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration("Masukan Tema"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Level
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<String>(
                        value: _difficulty,
                        isExpanded: true,
                        underline: Container(),
                        dropdownColor: Colors.orange[100],
                        onChanged: (value) =>
                            setState(() => _difficulty = value!),
                        items: List.generate(5, (i) => 'Level ${i + 1}')
                            .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Soal-soal
                    ...List.generate(
                      _questions.length,
                          (i) => SoalFormWidget(
                        index: i,
                        data: _questions[i],
                        onChanged: (updated) {
                          setState(() {
                            _questions[i] = updated;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tombol Export
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: exportToJson,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: const Icon(Icons.download, color: Colors.black),
                        label: const Text(
                          "Export Soal",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
