

import 'package:alien_quiz/screen/models/question_model.dart';

class QuizBundle {
  final String id;
  final String tema;
  final String level;
  final List<QuestionModel> questions;

  int? latestScore;

  QuizBundle({
    required this.id,
    required this.tema,
    required this.level,
    required this.questions,
    this.latestScore,
  });

  factory QuizBundle.fromJson(Map<String, dynamic> json) {
    return QuizBundle(
      id: json['id'],
      tema: json['tema'],
      level: json['level'],
      questions: (json['questions'] as List<dynamic>)
          .map((e) => QuestionModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tema': tema,
      'level': level,
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}
