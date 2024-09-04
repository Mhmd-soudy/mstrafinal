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
        title: const Text('Courses'),
      ),
      body: FutureBuilder(
        future: Provider.of<MainCategoryViewModel>(context, listen: false)
            .fetchSubCategorycourses(subCategoryId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load courses'));
          } else {
            return Consumer<MainCategoryViewModel>(
              builder: (ctx, subCategoryVM, child) {
                if (subCategoryVM.subCategory == null ||
                    subCategoryVM.subCategory!.courses.isEmpty) {
                  return const Center(child: Text('No courses available'));
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          RoutesManager.courseDetailScreen,
          arguments: course.slug,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: Row(
            children: [
              // Image Container
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  AppUrl.NetworkStorage + course.image,
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.1,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.04),
              // Course Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      course.name,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                            color: Colors.black87,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005),
                    Text(
                      course.price.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey[600],
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
