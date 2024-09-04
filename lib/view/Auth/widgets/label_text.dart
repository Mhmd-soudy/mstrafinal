import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LabelText extends StatelessWidget {
  LabelText({super.key, required this.labeltext});
  late String labeltext;
  @override
  Widget build(BuildContext context) {
    return Text(
      labeltext,
      style: const TextStyle(color: Colors.black, fontSize: 18),
    );
  }
}
