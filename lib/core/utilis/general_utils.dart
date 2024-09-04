import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/color_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: ColorManager.black,
        textColor: ColorManager.white);
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          forwardAnimationCurve: Curves.decelerate,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.all(15),
          message: message,
          duration: Duration(seconds: 3),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: ColorManager.errorColor,
          reverseAnimationCurve: Curves.easeInOut,
          positionOffset: 20,
          icon: Icon(
            Icons.error,
            size: 28,
            color: Colors.white,
          ),
        ));
  }

  static snackBar(
    String message,
    BuildContext context,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }
}
