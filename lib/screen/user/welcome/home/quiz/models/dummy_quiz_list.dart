import 'package:alien_quiz/screen/models/question_model.dart';
import 'quiz_bundle.dart';

final List<QuizBundle> dummyQuizList = [
  QuizBundle(
    id: "flutter-basic-001",
    tema: "Pemrograman Flutter",
    level: "Level 1",
    questions: [
      QuestionModel(
        question: "Apa itu Flutter?",
        options: ["Game engine", "Framework UI", "Plugin VS Code", "Bahasa Pemrograman", "Cloud Service"],
        correctAnswerIndex: 1,
      ),
      QuestionModel(
        question: "Bahasa utama Flutter?",
        options: ["Java", "Kotlin", "Swift", "Dart", "C++"],
        correctAnswerIndex: 3,
      ),
      QuestionModel(
        question: "Fungsi dari hot reload?",
        options: ["Restart emulator", "Ubah UI real-time", "Debugging", "Run project", "Install ulang"],
        correctAnswerIndex: 1,
      ),
      QuestionModel(
        question: "Paket navigasi di Flutter?",
        options: ["go_router", "http", "provider", "intl", "firebase_core"],
        correctAnswerIndex: 0,
      ),
      QuestionModel(
        question: "Widget bersifat stateful?",
        options: ["Text", "Container", "StatefulWidget", "Icon", "Row"],
        correctAnswerIndex: 2,
      ),
    ],
  ),
  QuizBundle(
    id: "dart-basic-001",
    tema: "Bahasa Dart",
    level: "Level 1",
    questions: [
      QuestionModel(
        question: "Apa itu Dart?",
        options: ["Framework", "Plugin", "Bahasa Pemrograman", "Database", "Hosting"],
        correctAnswerIndex: 2,
      ),
      QuestionModel(
        question: "Siapa pengembang Dart?",
        options: ["Microsoft", "Facebook", "Google", "Apple", "Mozilla"],
        correctAnswerIndex: 2,
      ),
      QuestionModel(
        question: "Kata kunci untuk membuat variabel di Dart?",
        options: ["var", "int", "const", "final", "let"],
        correctAnswerIndex: 0,
      ),
      QuestionModel(
        question: "Tipe data untuk angka pecahan?",
        options: ["int", "double", "String", "bool", "List"],
        correctAnswerIndex: 1,
      ),
      QuestionModel(
        question: "Bagaimana membuat list di Dart?",
        options: ["List()", "Array()", "Set()", "Map()", "Tuple()"],
        correctAnswerIndex: 0,
      ),
    ],
  ),
  QuizBundle(
    id: "firebase-intro-001",
    tema: "Firebase Dasar",
    level: "Level 2",
    questions: [
      QuestionModel(
        question: "Firebase adalah?",
        options: ["Framework UI", "Plugin Flutter", "Layanan Backend", "Database lokal", "Game Engine"],
        correctAnswerIndex: 2,
      ),
      QuestionModel(
        question: "Fitur Firebase untuk autentikasi?",
        options: ["Firestore", "Auth", "Storage", "Functions", "Analytics"],
        correctAnswerIndex: 1,
      ),
      QuestionModel(
        question: "Untuk menyimpan gambar, gunakan?",
        options: ["Auth", "Firestore", "Hosting", "Storage", "Functions"],
        correctAnswerIndex: 3,
      ),
      QuestionModel(
        question: "Firestore adalah tipe database?",
        options: ["Relasional", "Dokument", "SQL", "Real-time", "Graph"],
        correctAnswerIndex: 1,
      ),
      QuestionModel(
        question: "Fitur Firebase untuk real-time DB?",
        options: ["Firestore", "Realtime Database", "Storage", "Remote Config", "Analytics"],
        correctAnswerIndex: 1,
      ),
    ],
  ),
];
