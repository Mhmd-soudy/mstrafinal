import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/color_manager.dart';

InputDecoration formDecoration(
  String hinttext,
  IconData icondata,
) {
  return InputDecoration(
      errorStyle: const TextStyle(
        fontSize: 10,
      ),
      hintTextDirection: TextDirection.rtl,
      suffixIcon: Icon(
        icondata,
        color: ColorManager.indigoAccent,
      ),
      errorMaxLines: 3,
      hintText: hinttext,
      contentPadding: const EdgeInsets.all(5),
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 17,
      ),
      enabledBorder: enabledborder,
      focusedBorder: focusedborder,
      errorBorder: errorborder);
}

const enabledborder = UnderlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(width: 1, color: ColorManager.indigoAccent));
const focusedborder = UnderlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(width: 2, color: ColorManager.indigoAccent));
const errorborder = UnderlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(width: 2, color: ColorManager.errorColor));
