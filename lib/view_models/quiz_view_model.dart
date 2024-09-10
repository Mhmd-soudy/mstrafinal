import 'package:flutter/material.dart';
import 'package:mstra/models/quiz_model.dart';
import 'package:mstra/models/quizzes_results.dart';
import 'package:mstra/services/quizzes_services.dart';
// Create a model to represent the quiz results response.

class QuizViewModel extends ChangeNotifier {
  QuizModel? _quiz; // Store the full quiz model
  Map<int, String> _answers = {}; // Store user's answers by question ID
  bool _isLoading = false;
  String? _errorMessage;
  List<QuizResult> _quizResults = []; // Store quiz results for the user

  QuizModel? get quiz => _quiz;
  Map<int, String> get answers => _answers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<QuizResult> get quizResults => _quizResults; // Getter for quiz results

  /// Fetch Quiz Questions
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

  /// Check if all questions are answered
  bool get allAnswered {
    return _quiz != null && _answers.length == _quiz!.questions.length;
  }

  /// Submit User Score
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

  /// Fetch Quiz Results for the User in a Specific Course
  void fetchUserQuizResults(
      BuildContext context, int userId, int courseId) async {
    _isLoading = true;
    _errorMessage = null; // Reset error message
    notifyListeners();

    try {
      final quizzesServices = QuizzesServices();
      _quizResults = await quizzesServices.fetchQuizResults(
        userId,
      );

      if (_quizResults.isEmpty) {
        _errorMessage = 'No quiz results found for this course.';
        _showDialog(context, 'Info', _errorMessage!);
      }
    } catch (e) {
      _errorMessage = 'Error fetching quiz results: $e';
      _showDialog(context, 'Error', _errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch Quiz Results based on Course ID and Quiz ID
  void fetchQuizResultsByCourseAndQuiz(
      BuildContext context, int courseId, int quizId) async {
    _isLoading = true;
    _errorMessage = null; // Reset error message
    notifyListeners();

    try {
      final quizzesServices = QuizzesServices();
      _quizResults = await quizzesServices.fetchQuizResultsByCourseAndQuiz(
          courseId, quizId);

      if (_quizResults.isEmpty) {
        _errorMessage = 'No quiz results found for this quiz and course.';
        _showDialog(context, 'Info', _errorMessage!);
      }
    } catch (e) {
      _errorMessage = 'Error fetching quiz results: $e';
      _showDialog(context, 'Error', _errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Show a dialog for displaying messages
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
