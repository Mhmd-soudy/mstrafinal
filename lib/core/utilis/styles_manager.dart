import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/font_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: FontConstants.fontFamily,
      color: color,
      fontWeight: fontWeight);
}

// Regular Style

TextStyle getRegularStyle(double fontSize, FontWeight fontWeight, Color color) {
  return _getTextStyle(fontSize, FontWeightManager.regular, color);
}

// Light Style

TextStyle getLightStyle(double fontSize, FontWeight fontWeight, Color color) {
  return _getTextStyle(fontSize, FontWeightManager.light, color);
}

// Medium Style

TextStyle getMediumStyle(double fontSize, FontWeight fontWeight, Color color) {
  return _getTextStyle(fontSize, FontWeightManager.medium, color);
}

// SemiBold Style

TextStyle getSemiBoldStyle(
    double fontSize, FontWeight fontWeight, Color color) {
  return _getTextStyle(fontSize, FontWeightManager.semiBold, color);
}

// Bold Style

TextStyle getBoldStyle(double fontSize, FontWeight fontWeight, Color color) {
  return _getTextStyle(fontSize, FontWeightManager.bold, color);
}
