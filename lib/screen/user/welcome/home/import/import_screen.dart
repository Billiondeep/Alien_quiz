import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImportScreen extends StatefulWidget {
  final Map<String, dynamic>? sharedJson;

  const ImportScreen({super.key, this.sharedJson});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.sharedJson != null) {
      _importData(widget.sharedJson!);
    }
  }

  Future<void> _importData(Map<String, dynamic> jsonData) async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final existing = prefs.getStringList('imported_quiz_list') ?? [];

      // 🛠️ Normalisasi structure, pastikan valid
      final cleaned = {
        'id': jsonData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'tema': jsonData['tema'] ?? 'Tanpa Tema',
        'level': jsonData['level'] ?? 'Level 1',
        'questions': (jsonData['questions'] as List)
            .map((q) => Map<String, dynamic>.from(q))
            .toList(),
      };

      final updatedList = [jsonEncode(cleaned), ...existing];
      if (updatedList.length > 5) {
        updatedList.removeRange(5, updatedList.length);
      }

      await prefs.setStringList('imported_quiz_list', updatedList);
      await prefs.setString('imported_quiz', jsonEncode(cleaned));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Soal berhasil diimpor")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Gagal impor file: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }


  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        if (!await file.exists()) throw Exception("File tidak ditemukan");

        final content = await file.readAsString();
        dynamic decoded = jsonDecode(content);

        if (decoded is Map<String, dynamic>) {
          await _importData(decoded);
        } else {
          throw Exception("File bukan format quiz valid (harus JSON object).");
        }
      }
    } catch (e, stack) {
      debugPrint('❌ Exception saat import: $e');
      debugPrint(stack.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Gagal membaca file: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sharedJson != null || isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF2C233D),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF2C233D),
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text(
          "Import Manual",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: Text(
              "Masukan File Quiz yang ingin di Import dalam\nbentuk Format File JSON.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Center(
            child: Container(
              width: 260,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    offset: Offset(4, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.download, size: 48, color: Colors.black),
                  const SizedBox(height: 12),
                  const Text(
                    "Drag and Drop here\nor",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _pickFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                    ),
                    child: const Text("Import Soal"),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              "Pastikan File yang akan di Import benar.",
              style: TextStyle(color: Colors.white60),
            ),
          ),
        ],
      ),
    );
  }
}
