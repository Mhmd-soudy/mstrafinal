import 'package:flutter/material.dart';
import 'package:mstra/models/quiz_model.dart';
import 'package:mstra/services/quizzes_services.dart';

class QuizViewModel extends ChangeNotifier {
  QuizModel? _quiz; // Store the full quiz model
  Map<int, String> _answers = {};
  bool _isLoading = false;
  String? _errorMessage;

  QuizModel? get quiz => _quiz;
  Map<int, String> get answers => _answers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void fetchQuizQuestions(
      int quizId, int courseId, BuildContext context) async {
    _isLoading = true;
    _errorMessage = null; // Reset error message
    notifyListeners();

    try {
      final quizzesServices = QuizzesServices();
      _quiz = await quizzesServices.fetchQuiz(quizId, courseId);

      if (_quiz == null) {
        _errorMessage = 'Failed to load quiz data.';
        _showDialog(context, 'Error', _errorMessage!);
      }
    } catch (e) {
      _errorMessage = 'Error fetching quiz: $e';
      _showDialog(context, 'Error', _errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool get allAnswered {
    return _quiz != null && _answers.length == _quiz!.questions.length;
  }

  void submitUserScore(
      BuildContext context, int userId, int quizId, int score) async {
    try {
      final quizzesServices = QuizzesServices();
      final responseMessage =
          await quizzesServices.submitUserScore(userId, quizId, score);

      // Display the success or error message returned from the API
      _showDialog(context, 'Message', responseMessage);
    } catch (e) {
      // In case of an exception, display the error message
      _showDialog(context, 'Error', 'Error: $e');
    }
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
