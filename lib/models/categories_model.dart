import 'package:mstra/models/course_model.dart';

class SubCategory {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int mainCategoryId;
  final int coursesCount;
  final List<CourseModel> courses;

  SubCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.mainCategoryId,
    required this.coursesCount,
    required this.courses,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    // Check if the 'courses' key exists and if it's a list
    var courseList = json['courses'] as List<dynamic>? ?? [];

    // Map the list to CourseModel
    List<CourseModel> courses = courseList
        .map((courseJson) => CourseModel.fromJson(courseJson))
        .toList();

    return SubCategory(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      mainCategoryId: json['main_category_id'],
      coursesCount: json['courses_count'] ?? 0,
      courses: courses,
    );
  }
}

class MainCategory {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SubCategory> subCategories;

  MainCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.subCategories,
  });

  factory MainCategory.fromJson(Map<String, dynamic> json) {
    var subCategoriesJson = json['categories'] as List<dynamic>? ?? [];
    List<SubCategory> subCategories = subCategoriesJson
        .map((subcategory) => SubCategory.fromJson(subcategory))
        .toList();

    return MainCategory(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      subCategories: subCategories,
    );
  }
}
