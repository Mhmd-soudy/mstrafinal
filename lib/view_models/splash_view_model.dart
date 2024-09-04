import 'package:flutter/material.dart';
import 'package:mstra/routes/routes_manager.dart';

class SplashViewModel extends ChangeNotifier {
  Future<void> navigateToNextScreen(BuildContext context) async {
    Navigator.pushReplacementNamed(context, RoutesManager.homePage);
  }
}
