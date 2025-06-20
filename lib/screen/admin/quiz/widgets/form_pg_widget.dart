import 'package:flutter/material.dart';
import '../../../models/question_model.dart';

class FormPgWidget extends StatefulWidget {
  final int index;
  final QuestionModel model;
  final ValueChanged<QuestionModel>? onChanged;

  const FormPgWidget({
    super.key,
    required this.index,
    required this.model,
    this.onChanged,
  });

  @override
  State<FormPgWidget> createState() => _FormPgWidgetState();
}

class _FormPgWidgetState extends State<FormPgWidget> {
  late TextEditingController questionController;
  late List<TextEditingController> optionControllers;
  int selectedCorrectIndex = 0;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.model.question);
    optionControllers = List.generate(
      5,
          (i) => TextEditingController(text: widget.model.options[i]),
    );
    selectedCorrectIndex = widget.model.correctAnswerIndex;

    questionController.addListener(_notifyChange);
    for (var controller in optionControllers) {
      controller.addListener(_notifyChange);
    }
  }

  void _notifyChange() {
    final updatedModel = QuestionModel(
      question: questionController.text,
      options: optionControllers.map((c) => c.text).toList(),
      correctAnswerIndex: selectedCorrectIndex,
    );
    widget.onChanged?.call(updatedModel);
  }

  @override
  void dispose() {
    questionController.dispose();
    for (var c in optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2C233D),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange, width: 1),
        ),
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                "Buat Soal ${widget.index + 1}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              trailing: Icon(
                isExpanded ? Icons.remove : Icons.add,
                color: Colors.orange,
              ),
              onTap: () => setState(() => isExpanded = !isExpanded),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1B29),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Pertanyaan", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: questionController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _darkInput("Pertanyaan"),
                    ),
                    const SizedBox(height: 16),
                    const Text("Jawaban Pilihan Ganda", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    ...List.generate(5, (j) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextField(
                          controller: optionControllers[j],
                          style: const TextStyle(color: Colors.white),
                          decoration: _darkInput("Jawaban ${j + 1}"),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: selectedCorrectIndex,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF1C1B29),
                      style: const TextStyle(color: Colors.white),
                      decoration: _darkInput("Jawaban Benar: ${selectedCorrectIndex + 1}"),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => selectedCorrectIndex = val);
                          _notifyChange();
                        }
                      },
                      items: List.generate(5, (j) => DropdownMenuItem(
                        value: j,
                        child: Text('Jawaban ${j + 1}'),
                      )),
                    ),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _darkInput(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white54),
    filled: true,
    fillColor: const Color(0xFF2C233D),
    border: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white54),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white30),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}