import 'package:mstra/models/user_model_auth.dart';

class LoginResponse {
  final String accessToken;
  final User user;

  LoginResponse({required this.accessToken, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      user: User.fromJson(json['data']['0']),
    );
  }
}
