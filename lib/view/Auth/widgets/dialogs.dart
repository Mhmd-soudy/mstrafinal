import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/color_manager.dart';

void showSnackBar(BuildContext context, String message, int duration) {
  final snackBar = SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
    backgroundColor: ColorManager.indigoAccent,
    duration: Duration(milliseconds: duration),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10))),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
