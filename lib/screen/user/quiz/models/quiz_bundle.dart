import 'question_model.dart';

class QuizBundle {
  final String id;
  final String tema;
  final String level;
  final List<QuestionModel> questions;

  QuizBundle({
    required this.id,
    required this.tema,
    required this.level,
    required this.questions,
  });

  factory QuizBundle.fromJson(Map<String, dynamic> json) {
    return QuizBundle(
      id: json['id'],
      tema: json['tema'],
      level: json['level'],
      questions: (json['questions'] as List)
          .map((e) => QuestionModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tema': tema,
    'level': level,
    'questions': questions.map((q) => q.toJson()).toList(),
  };
}
