import 'package:flutter/material.dart';
import 'package:mstra/view/Auth/login/login_page.dart';
import 'package:mstra/view/Auth/register/register_page.dart';
import 'package:mstra/view/corses%20pages/Subscription%20page.dart';
import 'package:mstra/view/corses%20pages/course_search_screen.dart';
import 'package:mstra/view/corses%20pages/course_details/coursedetailscreen.dart';

import 'package:mstra/view/home%20pages/myhome.dart';
import 'package:mstra/view/home%20pages/profile%20Pages/team_members.dart';
import 'package:mstra/view/home%20pages/profile%20Pages/user_profile_screen.dart';

import 'package:mstra/view/splash/splash_screen.dart';

class RoutesManager {
  static const String splashScreen = "/";
  static const String loginPage = "/loginPage";
  static const String registerPage = "/registerPage";
  static const String homePage = "/homePage";
  static const String resetPasswordPage = "/resetPasswordPage";
  static const String searchScreen = "/searchScreen";
  static const String userProfileScreen = "/userProfileScreen";
  static const String teamMembersScreen = "/teamMembersScreen";
  static const String courseDetailScreen = "/course-detail";
  static const String webViewScreen = "/web_view_screen";
  static const String subscriptionPage = "/subscriptionPage";

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      //route for Splash Screen
      case splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      // case webViewScreen:
      //  final pdfUrl =
      //       settings.arguments as String;
      //   return MaterialPageRoute(builder: (context) => WebViewScreen(pdfUrl:pdfUrl));
      case searchScreen:
        return MaterialPageRoute(builder: (context) => CourseSearchScreen());
      //route for Login Page
      case loginPage:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case subscriptionPage:
        final coursePrice = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => Subscriptionpage(
                  coursePrice: coursePrice,
                ));
      case teamMembersScreen:
        return MaterialPageRoute(builder: (context) => const TeamMembers());

      case userProfileScreen:
        return MaterialPageRoute(builder: (context) => UserProfileScreen());
      // //route for Register Page
      case registerPage:
        return MaterialPageRoute(builder: (context) => const RegisterPage());
      case homePage:
        return MaterialPageRoute(builder: (context) => const MyHomePage());
      case courseDetailScreen:
        final slug =
            settings.arguments as String; // Retrieve the slug from arguments
        return MaterialPageRoute(
            builder: (context) => CourseDetailScreen(
                slug: slug)); // Pass slug to CourseDetailScreen
      // case resetPasswordPage:
      //   return MaterialPageRoute(builder: (context) => ResetPassword());
      default:
        throw Exception("No Route found!");
    }
  }
}
