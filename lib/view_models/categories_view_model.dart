import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mstra/models/categories_model.dart';
import 'package:mstra/res/app_url.dart';

class MainCategoryViewModel extends ChangeNotifier {
  List<MainCategory> _mainCategories = [];
  SubCategory? _subCategory;

  List<MainCategory> get mainCategories => _mainCategories;

  SubCategory? get subCategory => _subCategory;

  Future<void> fetchSubCategorycourses(int subCategoryId) async {
    final url = Uri.parse(
        '${AppUrl.subCategoryCoursesEndPoint}/$subCategoryId'); // Replace with your API URL

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _subCategory = SubCategory.fromJson(jsonData);
        notifyListeners();
      } else {
        throw Exception('Failed to load subcategory courses');
      }
    } catch (error) {
      print('Error fetching subcategory courses: $error');
    }
  }

  Future<void> fetchMainCategories() async {
    final url =
        Uri.parse(AppUrl.CategoriesEndPoint); // Replace with your API URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      _mainCategories =
          jsonData.map((json) => MainCategory.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> fetchSubCategories(int mainCategoryId) async {
    final url = Uri.parse(
        '${AppUrl.CategoriesEndPoint}/$mainCategoryId'); // Replace with your API URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final mainCategory = MainCategory.fromJson(jsonData);
      _mainCategories[_mainCategories.indexWhere(
          (element) => element.id == mainCategoryId)] = mainCategory;
      notifyListeners();
    } else {
      throw Exception('Failed to load subcategories');
    }
  }
}
