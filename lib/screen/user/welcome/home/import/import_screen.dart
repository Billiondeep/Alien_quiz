import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImportScreen extends StatelessWidget {
  const ImportScreen({super.key});

  Future<void> _importSoal(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final bytes = result.files.single.bytes;
        final content = bytes != null
            ? String.fromCharCodes(bytes)
            : await File(result.files.single.path!).readAsString();

        final parsedJson = jsonDecode(content);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('imported_quiz', jsonEncode(parsedJson));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Soal berhasil diimpor")),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("❌ File tidak dipilih")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Gagal impor soal: $e")),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2F),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text("Import File Soal"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Masukkan File Quiz dalam format JSON. Quiz akan ditampilkan di Home setelah berhasil diimpor.",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Spacer(),
          Center(
            child: Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.file_upload, size: 50),
                  const SizedBox(height: 10),
                  const Text("Upload File JSON"),
                  ElevatedButton(
                    onPressed: () => _importSoal(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text("Import Soal"),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[800],
            child: const Text(
              "Pastikan format file sudah sesuai struktur JSON Quiz.",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
