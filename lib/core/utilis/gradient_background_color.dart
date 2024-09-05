import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // Color(0xFFeefff0), // #eefff0
            // Color(0xFFffffff), // #fff
            Color.fromARGB(255, 213, 237, 216), // #eefff0
            Color.fromARGB(255, 255, 255, 255), // #fff
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
