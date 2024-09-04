import 'package:flutter/material.dart';
import 'package:mstra/models/course_model.dart';
import 'package:mstra/res/app_url.dart';
import 'package:mstra/routes/routes_manager.dart';
import 'package:mstra/view_models/categories_view_model.dart';
import 'package:provider/provider.dart';

class SubCategoryCoursesScreen extends StatelessWidget {
  final int subCategoryId;

  SubCategoryCoursesScreen({required this.subCategoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
      ),
      body: FutureBuilder(
        future: Provider.of<MainCategoryViewModel>(context, listen: false)
            .fetchSubCategorycourses(subCategoryId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load courses'));
          } else {
            return Consumer<MainCategoryViewModel>(
              builder: (ctx, subCategoryVM, child) {
                if (subCategoryVM.subCategory == null ||
                    subCategoryVM.subCategory!.courses.isEmpty) {
                  return Center(child: Text('No courses available'));
                } else {
                  return ListView.builder(
                    itemCount: subCategoryVM.subCategory!.courses.length,
                    itemBuilder: (ctx, index) {
                      final course = subCategoryVM.subCategory!.courses[index];
                      return CourseListItem(course: course);
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class CourseListItem extends StatelessWidget {
  final CourseModel course;

  const CourseListItem({required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            '${AppUrl.NetworkStorage}${course.image}',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          course.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          course.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.of(context).pushNamed(
            RoutesManager.courseDetailScreen,
            arguments: course.slug,
          );
        },
      ),
    );
  }
}
