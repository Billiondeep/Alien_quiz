import 'package:flutter/material.dart';

class SoalFormWidget extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const SoalFormWidget({
    super.key,
    required this.index,
    required this.data,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        backgroundColor: Colors.orange,
        collapsedBackgroundColor: Colors.orange.shade700,
        textColor: Colors.white,
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        title: Text(
          "Buat Soal ${index + 1}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        childrenPadding: const EdgeInsets.all(12),
        children: [
          // Label Pertanyaan
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Pertanyaan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Input Pertanyaan
          TextField(
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              hintText: 'Masukan Pertanyaan',
              hintStyle: TextStyle(color: Colors.black54),
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
            onChanged: (val) {
              final updated = {...data, 'question': val};
              onChanged(updated);
            },
          ),

          const SizedBox(height: 16),

          // Label Pilihan Ganda
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Jawaban Pilihan Ganda',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Input Jawaban 1-5
          ...List.generate(5, (j) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(
                    'Jawaban ${j + 1} : ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Masukan Jawaban',
                        hintStyle: TextStyle(color: Colors.black45),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        final updatedOptions = List<String>.from(data['options']);
                        updatedOptions[j] = val;
                        final updated = {...data, 'options': updatedOptions};
                        onChanged(updated);
                      },
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 10),

          // Dropdown Jawaban Benar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              value: data['answer'],
              isExpanded: true,
              underline: Container(),
              dropdownColor: Colors.orange[100],
              style: const TextStyle(color: Colors.black),
              onChanged: (val) {
                final updated = {...data, 'answer': val};
                onChanged(updated);
              },
              items: List.generate(5, (j) {
                final jawaban = 'Jawaban ${j + 1}';
                return DropdownMenuItem(
                  value: jawaban,
                  child: Text(jawaban),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
