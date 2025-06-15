import 'package:alien_quiz/screen/user/quiz/models/question_model.dart';
import 'package:alien_quiz/screen/user/quiz/models/quiz_bundle.dart';

final QuizBundle dummyQuiz = QuizBundle(
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
);
