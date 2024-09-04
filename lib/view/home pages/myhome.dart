import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/assets_manager.dart';
import 'package:mstra/core/utilis/color_manager.dart';
import 'package:mstra/core/utilis/font_manager.dart';
import 'package:mstra/models/navigation_model.dart';
import 'package:mstra/routes/routes_manager.dart';
import 'package:mstra/services/connectivity_service.dart';
import 'package:mstra/view/home%20pages/CategoriesScreen.dart';
import 'package:mstra/view/home%20pages/home_page.dart';
import 'package:mstra/view/home%20pages/my_courses_page.dart';
import 'package:mstra/view/home%20pages/profile%20Pages/profile_page.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ConnectivityService _connectivityService;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _connectivityService =
        Provider.of<ConnectivityService>(context, listen: false);

    // Listen to connectivity changes
    _connectivityService.connectivityStream.listen((result) {
      _updateConnectivityStatus(result);
    });

    // Check current connectivity on app start
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await _connectivityService.getCurrentConnectivity();
    _updateConnectivityStatus(result);
  }

  void _updateConnectivityStatus(ConnectivityResult result) {
    setState(() {
      _hasInternet = result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationModel = Provider.of<NavigationModel>(context);

    return Scaffold(
      appBar: AppBar(
        shadowColor: ColorManager.grey,
        elevation: 3,
        backgroundColor: ColorManager.primary,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RoutesManager.searchScreen);
            },
            icon: Icon(
              Icons.search,
              color: ColorManager.grey,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Image.asset(
              ImageAssets.splashLogo,
              height: MediaQuery.of(context).size.height * 0.04,
              width: MediaQuery.of(context).size.width * 0.2,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      body: _hasInternet
          ? IndexedStack(
              index: navigationModel.currentIndex,
              children: [
                ProfilePage(),
                MyCoursesPage(),
                CategoriesScreen(),
                HomePage(),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImageAssets
                      .nointernetConnection), // Your no internet connection image
                  const SizedBox(height: 20),
                  const Text(
                    'No internet connection',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: ColorManager.black,
        unselectedItemColor: ColorManager.grey,
        currentIndex: navigationModel.currentIndex,
        onTap: (index) {
          navigationModel.currentIndex = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'حسابي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'كورساتي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_rounded),
            label: 'المسارات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _connectivityService.dispose(); // Dispose of the service when done
    super.dispose();
  }
}
