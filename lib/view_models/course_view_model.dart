import 'package:flutter/material.dart';
import 'package:mstra/res/app_url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/course_model.dart';

class CoursesViewModel extends ChangeNotifier {
  List<CourseModel> _courses = [];
  List<CourseModel> _filteredCourses = [];
  bool _isLoading = false;
  String _error = '';

  List<CourseModel> get courses =>
      _filteredCourses.isNotEmpty ? _filteredCourses : _courses;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchCourses() async {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
    try {
      final response = await http.get(Uri.parse(AppUrl.coursesEndPoint));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _courses = data.map((json) => CourseModel.fromJson(json)).toList();
        _filteredCourses = _courses;
        _error = '';
      } else {
        _error = 'Failed to load courses';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCourses(String query) {
    if (query.isEmpty) {
      _filteredCourses = _courses;
    } else {
      _filteredCourses = _courses.where((course) {
        return course.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
