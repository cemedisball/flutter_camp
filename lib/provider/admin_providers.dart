import 'package:flutter/material.dart';
import 'package:flutter_camp/models/admin_model.dart';

class AdminProviders extends ChangeNotifier {
  String? _user;
  String? accesToken;
  String? refreshToken;

  String get user => _user!;
  String get accessToken => accesToken!;
  String get RefreshToken => refreshToken!;

  void onLogin(Admin adminModel) {
    _user = adminModel.username;
    accesToken = adminModel.accessToken;
    refreshToken = adminModel.refreshToken;
    notifyListeners();
  }

  void onLogout() {
    user;
    accesToken = null;
    refreshToken = null;
    notifyListeners();
  }

  void updadateAccessToken(String token) {
    accesToken = token;
    if (RefreshToken != null) {
      refreshToken = RefreshToken;
    }
    notifyListeners();
  }
}
