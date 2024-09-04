import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/assets_manager.dart';
import 'package:mstra/core/utilis/gradient_background_color.dart';
import 'package:mstra/models/course_model.dart';
import 'package:mstra/res/app_url.dart';
import 'package:mstra/routes/routes_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyCoursesPage extends StatefulWidget {
  @override
  _MyCoursesPageState createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  late Future<bool> _loggedInFuture;
  late Future<List<CourseModel>> _coursesFuture;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _loggedInFuture = _isLoggedIn();
  }

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    return accessToken != null; // Returns true if logged in, false otherwise
  }

  Future<List<CourseModel>> _loadCourses() async {
    final prefs = await SharedPreferences.getInstance();
    _userRole = prefs.getString('role');
    String? jsonString;

    if (_userRole == 'user') {
      jsonString = prefs.getString('purchased_courses');
    } else if (_userRole == 'teacher') {
      jsonString = prefs.getString('created_courses');
    }

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => CourseModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: FutureBuilder<bool>(
          future: _loggedInFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data == true) {
              // User is logged in, load courses
              _coursesFuture = _loadCourses();
              return FutureBuilder<List<CourseModel>>(
                future: _coursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No courses available.'));
                  }

                  final courses = snapshot.data!;
                  return ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              RoutesManager.courseDetailScreen,
                              arguments:
                                  course.slug, // Pass the slug as an argument
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 4,
                            margin: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Image Container
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.18,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            AppUrl.NetworkStorage +
                                                course.image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.018),
                                  // Course Name
                                  Text(
                                    course.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.008),
                                  // User Information Row
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              // User is not logged in, show login button
              return Scaffold(
                body: GradientBackground(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Image.asset(
                                  fit: BoxFit.contain,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width: double.infinity,
                                  ImageAssets.notloggedin)),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RoutesManager.loginPage);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 93, 142, 92),
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Rounded corners
                            ),
                            elevation: 5, // Text color
                          ),
                          child: const Text('اذهب الى صفحة تسجيل الدخول'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
