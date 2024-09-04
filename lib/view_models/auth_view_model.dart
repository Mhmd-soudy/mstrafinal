import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mstra/models/login_response_model.dart';
import 'package:mstra/models/user_model_auth.dart';
import 'package:mstra/res/app_url.dart';
import 'package:mstra/routes/routes_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';

class AuthViewModel with ChangeNotifier {
  User? _user;
  String? _accessToken;
  String? _userRole;

  User? get user => _user;
  String? get accessToken => _accessToken;
  String? get userRole => _userRole;

  Future<String?> getAndroidId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id; // Returns the Android ID
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String? androidId = await getAndroidId();
    final url = Uri.parse(AppUrl.loginEndPoint);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Ensure the content type is JSON
      },
      body: json.encode({
        'email': email,
        'password': password,
        "ip_adress": androidId,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final loginResponse = LoginResponse.fromJson(responseData);

      // Extract data
      final createdCourses =
          responseData['data']['created_courses'] as List<dynamic>;
      final purchasedCourses =
          responseData['data']['purchased_courses'] as List<dynamic>;

      _userRole = responseData['data']['role'];
      _user = loginResponse.user;
      _accessToken = loginResponse.accessToken;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', _accessToken!);
      await prefs.setInt('id', _user!.id ?? 0);
      await prefs.setString('name', _user!.name);
      await prefs.setString('email', _user!.email);
      await prefs.setString('phone', _user!.phone);
      await prefs.setString('user_image', _user!.image ?? "");
      await prefs.setString('role', _userRole ?? "");

      // Save created_courses and purchased_courses as JSON strings
      await prefs.setString('created_courses', json.encode(createdCourses));
      await prefs.setString('purchased_courses', json.encode(purchasedCourses));

      // Display a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful'),
          backgroundColor: Colors.green,
        ),
      );

      notifyListeners();
      Navigator.pushReplacementNamed(context, RoutesManager.homePage);
    } else {
      final responseData = json.decode(response.body);
      final errorMessage = responseData['message'] ?? 'Unknown error';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage), // Display the exact message from the API
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Future<void> login({
  //   required String email,
  //   required String password,
  //   required BuildContext context,
  // }) async {
  //   final url = Uri.parse(AppUrl.loginEndPoint);
  //   final response = await http.post(url,
  //       headers: {
  //         'Content-Type': 'application/json', // Ensure the content type is JSON
  //       },
  //       body: json.encode({
  //         'email': email,
  //         'password': password,
  //       }));

  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> responseData = json.decode(response.body);
  //     final loginResponse = LoginResponse.fromJson(responseData);
  //     _userRole = jsonDecode(response.body)['data']['role'];

  //     _user = loginResponse.user;
  //     _accessToken = loginResponse.accessToken;

  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('access_token', _accessToken!);
  //     await prefs.setInt('id', _user!.id ?? 0);
  //     await prefs.setString('name', _user!.name);
  //     await prefs.setString('email', _user!.email);
  //     await prefs.setString('phone', _user!.phone);
  //     await prefs.setString('image', _user!.image ?? "");
  //     await prefs.setString('role', _userRole ?? "");

  //     // Display a success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Login successful'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );

  //     notifyListeners();
  //     Navigator.pushReplacementNamed(context, RoutesManager.homePage);
  //   } else {
  //     final responseData = json.decode(response.body);
  //     final errorMessage = responseData['message'] ?? 'Unknown error';

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(errorMessage), // Display the exact message from the API
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required BuildContext context,
  }) async {
    String? androidId = await getAndroidId();
    final url = Uri.parse(AppUrl
        .registerEndPoint); // Replace with your actual registration endpoint
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json', // Ensure the content type is JSON
        },
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          "password_confirmation": passwordConfirmation,
          "ip_adress": androidId,
        }));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final loginResponse = LoginResponse.fromJson(responseData);
      _userRole = jsonDecode(response.body)['data']['role'];

      _user = loginResponse.user;
      _accessToken = loginResponse.accessToken;
      notifyListeners();
      Navigator.pushReplacementNamed(context, RoutesManager.homePage);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', _accessToken!);
      await prefs.setInt('id', _user!.id ?? 0);
      await prefs.setString('name', _user!.name);
      await prefs.setString('email', _user!.email);
      await prefs.setString('phone', _user!.phone);
      await prefs.setString('user_image', _user!.image ?? "");
      await prefs.setString('role', _userRole ?? "");
    } else {
      final responseData = json.decode(response.body);
      final errorMessage = responseData['message'] ?? 'Unknown error';
      throw Exception('Registration failed: $errorMessage');
    }
  }

  Future<void> loadAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    if (_accessToken != null) {
      _user = User(
        id: prefs.getInt('id') ?? 0,
        name: prefs.getString('name') ?? '',
        email: prefs.getString('email') ?? '',
        phone: prefs.getString('phone') ?? "",
        image: prefs.getString('image'),
        emailVerifiedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        password: '',
        passwordConfirmation: '',
      );

      // Optionally, you can fetch the user data with the stored token
      // and set the _user property if needed.

      notifyListeners();
    }
  }

  void updateUser(User updatedUser) {
    _user = updatedUser;

    // Save the updated user details to SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('id', _user!.id ?? 0);
      prefs.setString('name', _user!.name);
      prefs.setString('email', _user!.email);
      prefs.setString('phone', _user!.phone);
      prefs.setString('image', _user!.image ?? "");
    });

    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');

    if (_accessToken != null) {
      final url = Uri.parse(AppUrl.logoutEndPoint);
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      print("access token $_accessToken");

      if (response.statusCode == 200) {
        _user = null;
        _accessToken = null;

        await prefs
            .clear(); // Clear all preferences instead of removing individual items

        notifyListeners();
        Navigator.pushReplacementNamed(context, RoutesManager.loginPage);
      } else {
        throw Exception('Failed to log out');
      }
    } else {
      throw Exception('No access token found');
    }
  }
}
