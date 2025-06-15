import 'package:flutter/material.dart';

class DifficultyDropdown extends StatelessWidget {
  final String selectedLevel;
  final ValueChanged<String> onChanged;

  const DifficultyDropdown({
    super.key,
    required this.selectedLevel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tingkat Kesulitan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.orange.shade600, // 🎨 Warna latar tombol dropdown
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<String>(
            value: selectedLevel,
            isExpanded: true,
            icon: const Icon(Icons.add_circle_rounded, color: Colors.white), // ✅ Ikon dropdown
            underline: Container(), // Hilangkan garis bawahan
            dropdownColor: Colors.orange[100], // Warna background menu dropdown
            style: const TextStyle(color: Colors.black), // Warna teks dalam dropdown
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
            items: List.generate(5, (i) => 'Level ${i + 1}')
                .map((level) => DropdownMenuItem(
              value: level,
              child: Text(level),
            ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
