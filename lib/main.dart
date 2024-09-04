import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:mstra/models/navigation_model.dart';
import 'package:mstra/routes/routes_manager.dart';
import 'package:mstra/services/connectivity_service.dart';
import 'package:mstra/view_models/auth_view_model.dart';
import 'package:mstra/view_models/categories_view_model.dart';
import 'package:mstra/view_models/course_view_model.dart';
import 'package:mstra/view_models/splash_view_model.dart';
import 'package:mstra/view_models/user_profile_View_model.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationModel()),
        ChangeNotifierProvider(
          create: (context) => SplashViewModel(),
        ),
        Provider<ConnectivityService>(
          create: (_) => ConnectivityService(),
        ),
        ChangeNotifierProvider(create: (_) => CoursesViewModel()),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => MainCategoryViewModel()),
        ChangeNotifierProvider(create: (_) => UserProfileViewModel()),
        // Provider<ConnectivityService>(
        //   create: (_) => ConnectivityService(),
        //   dispose: (context, service) => service.dispose(),
        // ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // _secureScreen();
    return MaterialApp(
      theme: ThemeData(
        // Set the default font for the app
        fontFamily: 'IBMPlexSansArabic',
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RoutesManager.onGenerateRoute,
      initialRoute: RoutesManager.splashScreen,
    );
  }

  // void _secureScreen() async {
  //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }
}
