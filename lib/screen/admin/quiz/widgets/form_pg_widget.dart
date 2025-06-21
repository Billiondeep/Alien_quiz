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
      padding: const EdgeInsets.only(bottom: 14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1B2E),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
          border: Border.all(color: Colors.orange.shade300, width: 1),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => setState(() => isExpanded = !isExpanded),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Buat Soal ${widget.index + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.orange,
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF1F1B2E),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Pertanyaan"),
                    const SizedBox(height: 6),
                    TextField(
                      controller: questionController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _darkInput("Masukan Pertanyaan"),
                    ),
                    const SizedBox(height: 16),
                    _sectionTitle("Jawaban Pilihan Ganda"),
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
                    const SizedBox(height: 12),
                    _sectionTitle("Jawaban yang Benar"),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      value: selectedCorrectIndex,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF1C1B29),
                      style: const TextStyle(color: Colors.white),
                      decoration: _darkInput("Pilih Jawaban Benar"),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => selectedCorrectIndex = val);
                          _notifyChange();
                        }
                      },
                      items: List.generate(
                        5,
                            (j) => DropdownMenuItem(
                          value: j,
                          child: Text('Jawaban ${j + 1}'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
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