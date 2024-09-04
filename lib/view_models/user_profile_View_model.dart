import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mstra/models/user_model_auth.dart';
import 'package:mstra/res/app_url.dart';
import 'package:mstra/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    await Future.delayed(Duration(seconds: 1));
    _user = existingUser;
    print('User data loaded: $_user');
    notifyListeners();
  }

  // Update User Data
  Future<void> updateUser(BuildContext context, User updatedUser) async {
    _isUpdating = true;
    notifyListeners();

    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      if (accessToken == null) {
        _errorMessage = 'User not logged in';
        return;
      }

      // Create a map to hold the updated fields
      final Map<String, dynamic> updates = {};

      // Check each field in the user model and add only the changed fields
      if (_user?.name != updatedUser.name) updates['name'] = updatedUser.name;
      if (_user?.email != updatedUser.email)
        updates['email'] = updatedUser.email;
      if (_user?.phone != updatedUser.phone)
        updates['phone'] = updatedUser.phone;
      if (_user?.image != updatedUser.image)
        updates['image'] = updatedUser.image;

      // Only proceed if there are updates to be made
      if (updates.isEmpty) {
        _errorMessage = 'No changes detected';
        return;
      }

      final response = await http.post(
        Uri.parse(AppUrl.updateProfileEndPoint),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updates), // Send only the updates
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Update the local user model with the new values
        _user = User(
          id: _user?.id ?? updatedUser.id,
          name: updates['name'] ?? _user?.name ?? '',
          email: updates['email'] ?? _user?.email ?? '',
          phone: updates['phone'] ?? _user?.phone ?? '',
          image: updates['image'] ?? _user?.image ?? "",
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
      } else {
        _errorMessage = 'Error updating user data';
      }
    } catch (e) {
      _errorMessage = 'An error occurred';
      print(e);
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
}
