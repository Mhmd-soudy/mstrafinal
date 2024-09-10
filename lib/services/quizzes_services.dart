import 'package:http/http.dart' as http;
import 'package:mstra/models/quiz_model.dart';
import 'package:mstra/models/quizzes_results.dart';
import 'package:mstra/res/app_url.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class QuizzesServices {
  // Helper method to get the access token from SharedPreferences
  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Fetch quiz details based on quiz ID and course ID
  Future<QuizModel?> fetchQuiz(int quizId, int courseId) async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception('Access token not found. Please log in again.');
      }

      final response = await http.get(
        Uri.parse(
            '${AppUrl.authenticatedSingleCourseEndPoint}/$courseId/quizzes/$quizId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return QuizModel.fromJson(data);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ??
            'Failed to load quiz: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching quiz: $e');
      return null;
    }
  }

  // Submit user's score for a quiz
  Future<String> submitUserScore(int userId, int quizId, int score) async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception('Access token not found. Please log in again.');
      }

      final response = await http.post(
        Uri.parse('${AppUrl.baseUrl}/quiz-results'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          'quiz_id': quizId,
          'user_id': userId,
          'mark': score,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final successResponse = json.decode(response.body);
        return successResponse['message'] ?? 'Score submitted successfully';
      } else if (response.statusCode == 400 || response.statusCode == 409) {
        final errorResponse = json.decode(response.body);
        return errorResponse['message'] ??
            'Failed to submit score: ${response.statusCode}';
      } else {
        throw Exception('Unexpected error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting score: $e');
      throw e;
    }
  }

  // Fetch quiz results for a user and course
  Future<List<QuizResult>> fetchQuizResults(
    int userId,
  ) async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception('Access token not found. Please log in again.');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/users/$userId/quiz-results'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> resultsJson = json.decode(response.body);
        return resultsJson.map((json) => QuizResult.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load quiz results: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching quiz results: $e');
      throw e;
    }
  }

  //  for teachers
  // Fetch quiz results based on course ID and quiz ID   for teachers
  Future<List<QuizResult>> fetchQuizResultsByCourseAndQuiz(
      int courseId, int quizId) async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception('Access token not found. Please log in again.');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/courses/$courseId/quizzes/$quizId/users'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> resultsJson = json.decode(response.body);
        return resultsJson.map((json) => QuizResult.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load quiz results: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching quiz results: $e');
      throw e;
    }
  }
}
