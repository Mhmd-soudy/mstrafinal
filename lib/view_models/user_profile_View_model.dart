import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mstra/models/user_model_auth.dart';
import 'package:mstra/res/app_url.dart';
import 'package:mstra/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class UserProfileViewModel extends ChangeNotifier {
  User? _user;
  bool _isUpdating = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;

  // Load User Data from the existing user model
  Future<void> loadUserDataFromModel(User existingUser) async {
    await Future.delayed(const Duration(seconds: 1));
    _user = existingUser;
    notifyListeners();
  }

  // Update User Data with optional image
  Future<void> updateUser(
    BuildContext context,
    User updatedUser, {
    File? imageFile,
  }) async {
    _isUpdating = true;
    notifyListeners();

    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      // Handle case where user is not logged in
      if (accessToken == null) {
        _errorMessage = 'User not logged in';
        return;
      }

      // Prepare a map to hold only the changed fields
      final Map<String, String> updates = {};

      if (_user?.name != updatedUser.name) updates['name'] = updatedUser.name;
      if (_user?.email != updatedUser.email)
        updates['email'] = updatedUser.email;
      if (_user?.phone != updatedUser.phone)
        updates['phone'] = updatedUser.phone;

      // Return if there are no changes and no image selected
      if (updates.isEmpty && imageFile == null) {
        _errorMessage = 'No changes detected';
        return;
      }

      // Prepare the multipart request for updating the profile
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.updateProfileEndPoint),
      );

      // Set headers
      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'multipart/form-data',
      });

      // Add the updated fields to the request
      updates.forEach((key, value) {
        request.fields[key] = value;
      });

      // Add the image file if present
      if (imageFile != null) {
        String fileName = basename(imageFile.path);
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path,
              filename: fileName),
        );
      }

      // Send the request and capture the response
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      // Check response status and update user data accordingly
      if (response.statusCode == 200) {
        // Update the local user model with the new values
        _user = User(
          id: _user?.id ?? updatedUser.id,
          name: updates['name'] ?? _user?.name ?? '',
          email: updates['email'] ?? _user?.email ?? '',
          phone: updates['phone'] ?? _user?.phone ?? '',
          image:
              imageFile != null ? basename(imageFile.path) : _user?.image ?? "",
          emailVerifiedAt:
              _user?.emailVerifiedAt ?? updatedUser.emailVerifiedAt,
          createdAt: _user?.createdAt ?? updatedUser.createdAt,
          updatedAt: DateTime.now(),
          password: '',
          passwordConfirmation: '',
        );

        _errorMessage = null;

        // Update the user in AuthViewModel as well
        authViewModel.updateUser(_user!);

        // Notify success
        _showSnackBar(context, 'Profile updated successfully!');
      } else {
        _errorMessage = 'Error updating user data: ${response.statusCode}';
        print('Update failed: $responseBody');
      }
    } catch (e) {
      _errorMessage = 'An error occurred while updating profile';
      print('Exception: $e');
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Utility function to display messages in a SnackBar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:mstra/models/user_model_auth.dart';
// import 'package:mstra/res/app_url.dart';
// import 'package:mstra/view_models/auth_view_model.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class UserProfileViewModel extends ChangeNotifier {
//   User? _user;
//   bool _isUpdating = false;
//   String? _errorMessage;

//   // Getters
//   User? get user => _user;
//   bool get isUpdating => _isUpdating;
//   String? get errorMessage => _errorMessage;

//   // Load User Data from the existing user model
//   Future<void> loadUserDataFromModel(User existingUser) async {
//     await Future.delayed(Duration(seconds: 1));
//     _user = existingUser;
//     print('User data loaded: $_user');
//     notifyListeners();
//   }

//   // Update User Data
//   Future<void> updateUser(BuildContext context, User updatedUser) async {
//     _isUpdating = true;
//     notifyListeners();

//     try {
//       final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
//       final prefs = await SharedPreferences.getInstance();
//       final accessToken = prefs.getString('access_token');
//       if (accessToken == null) {
//         _errorMessage = 'User not logged in';
//         return;
//       }

//       // Create a map to hold the updated fields
//       final Map<String, dynamic> updates = {};

//       // Check each field in the user model and add only the changed fields
//       if (_user?.name != updatedUser.name) updates['name'] = updatedUser.name;
//       if (_user?.email != updatedUser.email)
//         updates['email'] = updatedUser.email;
//       if (_user?.phone != updatedUser.phone)
//         updates['phone'] = updatedUser.phone;
//       if (_user?.image != updatedUser.image)
//         updates['image'] = updatedUser.image;

//       // Only proceed if there are updates to be made
//       if (updates.isEmpty) {
//         _errorMessage = 'No changes detected';
//         return;
//       }

//       final response = await http.post(
//         Uri.parse(AppUrl.updateProfileEndPoint),
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(updates), // Send only the updates
//       );
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         // Update the local user model with the new values
//         _user = User(
//           id: _user?.id ?? updatedUser.id,
//           name: updates['name'] ?? _user?.name ?? '',
//           email: updates['email'] ?? _user?.email ?? '',
//           phone: updates['phone'] ?? _user?.phone ?? '',
//           image: updates['image'] ?? _user?.image ?? "",
//           emailVerifiedAt:
//               _user?.emailVerifiedAt ?? updatedUser.emailVerifiedAt,
//           createdAt: _user?.createdAt ?? updatedUser.createdAt,
//           updatedAt: DateTime.now(),
//           password: '',
//           passwordConfirmation: '',
//         );

//         _errorMessage = null;

//         // Update the user in AuthViewModel as well
//         authViewModel.updateUser(_user!);
//       } else {
//         _errorMessage = 'Error updating user data';
//       }
//     } catch (e) {
//       _errorMessage = 'An error occurred';
//       print(e);
//     } finally {
//       _isUpdating = false;
//       notifyListeners();
//     }
//   }
// }
