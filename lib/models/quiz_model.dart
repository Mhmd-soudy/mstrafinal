import 'package:mstra/models/quiz_questions_model.dart';

class QuizModel {
  final int id;
  final String title;
  final int courseId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<QuizQuestions> questions;

  QuizModel({
    required this.id,
    required this.title,
    required this.courseId,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      courseId: json['course_id'] ?? 0,
      createdAt:
          DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt:
          DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
      questions: (json['questions'] as List? ?? [])
          .map((e) => QuizQuestions.fromJson(e))
          .toList(),
    );
  }
}
