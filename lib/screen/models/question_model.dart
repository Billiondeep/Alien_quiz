class QuestionModel {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex:
      json['correctAnswerIndex'] ?? json['correct_answer_index'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}
