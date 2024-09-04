import 'package:flutter/material.dart';
import 'package:mstra/view/corses%20pages/course_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CourseListView(),
    );
  }
}
