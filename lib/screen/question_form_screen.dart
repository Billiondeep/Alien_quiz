import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
      "questions": _questions
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C233D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Text(
                "Membuat Soal",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _temaController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Tema'),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _difficulty,
                isExpanded: true,
                dropdownColor: Colors.orange,
                onChanged: (value) => setState(() => _difficulty = value!),
                items: List.generate(5, (i) => 'Level ${i + 1}')
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Loop soal
              ...List.generate(_questions.length, (i) => ExpansionTile(
                    backgroundColor: Colors.orange,
                    collapsedBackgroundColor: Colors.orange.shade700,
                    title: Text("Buat Soal ${i + 1}", style: const TextStyle(color: Colors.white)),
                    childrenPadding: const EdgeInsets.all(12),
                    children: [
                      TextField(
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(labelText: 'Pertanyaan'),
                        onChanged: (val) => _questions[i]['question'] = val,
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(5, (j) => TextField(
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(labelText: 'Jawaban ${j + 1}'),
                            onChanged: (val) => _questions[i]['options'][j] = val,
                          )),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        value: _questions[i]['answer'],
                        isExpanded: true,
                        dropdownColor: Colors.orange,
                        onChanged: (val) => setState(() => _questions[i]['answer'] = val!),
                        items: List.generate(5, (j) => DropdownMenuItem(
                              value: 'Jawaban ${j + 1}',
                              child: Text('Jawaban ${j + 1}'),
                            )),
                      ),
                    ],
                  )),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: exportToJson,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                icon: const Icon(Icons.download),
                label: const Text("Export Soal"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
