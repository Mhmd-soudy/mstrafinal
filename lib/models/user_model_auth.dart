import 'package:mstra/models/course_model.dart';

class User {
  final int? id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String phone;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? password;
  final String? passwordConfirmation;
  final List<CourseModel>? createdCourses;
  final List<CourseModel>? purchasedCourses;

  User({
    this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.phone,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.password,
    this.passwordConfirmation,
    this.createdCourses,
    this.purchasedCourses,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0, // Handle null and default to 0
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      phone: json['phone'] as String? ?? '',
      image: json['image'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      password: '', // Assuming password should be empty here
      passwordConfirmation: '', // Assuming confirmation should be empty here
      createdCourses: (json['created_courses'] as List<dynamic>? ?? [])
          .map((course) => CourseModel.fromJson(course))
          .toList(),
      purchasedCourses: (json['purchased_courses'] as List<dynamic>? ?? [])
          .map((course) => CourseModel.fromJson(course))
          .toList(),
    );
  }
}
