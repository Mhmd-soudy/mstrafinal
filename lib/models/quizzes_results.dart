class QuizResult {
  final int? quizId;
  final int userId;
  final int mark;
  final String? quizName;
  final String? courseName;
  final String? courseId;
  final String? userName;

  QuizResult({
    this.quizId,
    required this.userId,
    required this.mark,
    this.quizName,
    this.courseName,
    this.courseId,
    this.userName,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      quizId: json['quiz_id'] as int?, // Nullable
      userId: json['user_id'] as int? ?? 0, // Default value if null
      mark: json['mark'] as int? ?? 0, // Default value if null
      quizName: json['quiz_name'] as String?, // Nullable
      courseName: json['course_name'] as String?, // Nullable
      courseId: json['course_id'] as String?, // Nullable
      userName: json['user_name'] as String?, // Nullable
    );
  }
}
