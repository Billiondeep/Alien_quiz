class QuestionModel {
  String question;
  List<String> options;
  int correctAnswerIndex;

  QuestionModel({
    this.question = '',
    List<String>? options,
    this.correctAnswerIndex = 0,
  }) : options = options ?? List.filled(5, '');

  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options,
    'correct_answer_index': correctAnswerIndex,
  };

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex: json['correct_answer_index'] ?? 0,
    );
  }
}
