import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:mstra/models/navigation_model.dart';
import 'package:mstra/routes/routes_manager.dart';
import 'package:mstra/services/connectivity_service.dart';
import 'package:mstra/view_models/AudioViewModel.dart';
import 'package:mstra/view_models/auth_view_model.dart';
import 'package:mstra/view_models/categories_view_model.dart';
import 'package:mstra/view_models/course_view_model.dart';
import 'package:mstra/view_models/notifications_view_model.dart';
import 'package:mstra/view_models/quiz_view_model.dart';
import 'package:mstra/view_models/splash_view_model.dart';
import 'package:mstra/view_models/user_profile_View_model.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
        ChangeNotifierProvider(create: (_) => QuizViewModel()),
        ChangeNotifierProvider(create: (_) => MediaViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PushNotificationService _pushNotificationService =
      PushNotificationService();

  @override
  void initState() {
    super.initState();
    // Pass the context to init method
    _pushNotificationService.init(context);
  }

  @override
  Widget build(BuildContext context) {
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
}
