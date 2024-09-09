import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mstra/models/course_model.dart';
import 'package:mstra/res/app_url.dart';
import 'package:mstra/routes/routes_manager.dart';
import 'package:mstra/view_models/categories_view_model.dart';
import 'package:provider/provider.dart';

class RelatedCourses extends StatefulWidget {
  final int categoriesId;
  final String courseslug;
  const RelatedCourses(
      {super.key, required this.categoriesId, required this.courseslug});

  @override
  State<RelatedCourses> createState() => _RelatedCoursesState();
}

class _RelatedCoursesState extends State<RelatedCourses> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<MainCategoryViewModel>(context, listen: false)
          .fetchSubCategorycourses(widget.categoriesId),
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
                // Filter out the course with the matching slug
                final filteredCourses = subCategoryVM.subCategory!.courses
                    .where((course) => course.slug != widget.courseslug)
                    .toList();

                // Check if there are no filtered courses
                if (filteredCourses.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: const Center(
                      child: Text(
                        'لا يوجد كورسات مشابهة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }

                // Display the filtered list
                return ListView.builder(
                  shrinkWrap: true, // Ensure the ListView is sized correctly
                  physics:
                      NeverScrollableScrollPhysics(), // Disable ListView scrolling
                  itemCount: filteredCourses.length,
                  itemBuilder: (ctx, index) {
                    final course = filteredCourses[index];
                    return CourseListItem(course: course);
                  },
                );
              }
            },
          );
        }
      },
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
