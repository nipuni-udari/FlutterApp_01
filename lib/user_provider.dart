import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  String _userHris = '';

  String get username => _username;
  String get userHris => _userHris;

  void setUser(String username, String userHris) {
    _username = username;
    _userHris = userHris;
    notifyListeners();
  }
}
