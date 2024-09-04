import 'package:flutter/material.dart';

// Models
class NavigationModel extends ChangeNotifier {
  int _currentIndex = 3;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }
}
