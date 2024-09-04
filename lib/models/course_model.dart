import 'package:mstra/models/category_model.dart';
import 'package:mstra/models/pdf_model.dart';
import 'package:mstra/models/record_model.dart';
import 'package:mstra/models/user_model_courses.dart';
import 'package:mstra/models/video_model.dart';

class CourseModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String image;
  final int? userId;
  final int usersCount;
  final String price;
  final int? students_count;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int buyersCount;
  late final bool hasCourse;
  final UserModel user;
  final List<CategoryModel> categories;
  final List<VideoModel> videos;
  final List<RecordModel> records;
  final List<PdfModel> pdfs;

  CourseModel(
      {required this.id,
      required this.name,
      required this.slug,
      required this.description,
      required this.image,
      required this.userId,
      required this.usersCount,
      required this.price,
      required this.createdAt,
      required this.updatedAt,
      required this.buyersCount,
      required this.hasCourse,
      required this.user,
      required this.categories,
      required this.videos,
      required this.records,
      required this.pdfs,
      this.students_count});

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      userId: json['user_id'] ?? 0,
      usersCount: json['users_count'] ?? 0,
      students_count: json["students_count"] ?? 0,
      price: json['price'] ?? '',
      createdAt:
          DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt:
          DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
      buyersCount: json['buyers_count'] ?? 0,
      hasCourse: json['has_course'] ?? false,
      user: UserModel.fromJson(json['user'] ?? {}),
      categories: (json['categories'] as List? ?? [])
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
      videos: (json['videos'] as List? ?? [])
          .map((e) => VideoModel.fromJson(e))
          .toList(),
      records: (json['records'] as List? ?? [])
          .map((e) => RecordModel.fromJson(e))
          .toList(),
      pdfs: (json['pdfs'] as List? ?? [])
          .map((e) => PdfModel.fromJson(e))
          .toList(),
    );
  }
}
