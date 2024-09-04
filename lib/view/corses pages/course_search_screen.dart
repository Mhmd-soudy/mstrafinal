import 'package:flutter/material.dart';
import 'package:mstra/res/app_url.dart';
import 'package:mstra/routes/routes_manager.dart';
import 'package:mstra/view_models/course_view_model.dart';
import 'package:provider/provider.dart';

class CourseSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final coursesViewModel = Provider.of<CoursesViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search courses...',
          ),
          onChanged: (query) {
            coursesViewModel.searchCourses(query);
          },
        ),
      ),
      body: coursesViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : coursesViewModel.error.isNotEmpty
              ? Center(child: Text(coursesViewModel.error))
              : ListView.builder(
                  itemCount: coursesViewModel.courses.length,
                  itemBuilder: (context, index) {
                    final course = coursesViewModel.courses[index];
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RoutesManager.courseDetailScreen,
                            arguments: course.slug,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
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
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 16),
                                // Course Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        course.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        course.user.name.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Colors.grey[600],
                                              fontSize: 14,
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
                        ));
                  },
                ),
    );
  }
}
