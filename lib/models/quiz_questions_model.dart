class QuizQuestions {
  final int id;
  final int quizId;
  final String questionText;
  final List<Option> options;

  QuizQuestions({
    required this.id,
    required this.quizId,
    required this.questionText,
    required this.options,
  });

  factory QuizQuestions.fromJson(Map<String, dynamic> json) {
    var optionsFromJson = json['options'] as List;
    List<Option> optionsList =
        optionsFromJson.map((i) => Option.fromJson(i)).toList();

    return QuizQuestions(
      id: json['id'] as int,
      quizId: json['quiz_id'] as int,
      questionText: json['question_text'] as String,
      options: optionsList,
    );
  }
}

class Option {
  final int id;
  final int questionId;
  final String optionText;
  final int isCorrect;

  Option({
    required this.id,
    required this.questionId,
    required this.optionText,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] as int,
      questionId: json['question_id'] as int,
      optionText: json['option_text'] as String,
      isCorrect: json['is_correct'] as int,
    );
  }
}
