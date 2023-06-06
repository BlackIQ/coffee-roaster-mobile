import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _authenticated = false;
  String _theme = 'light';

  bool get getAuthenticated {
    return _authenticated;
  }

  String get getTheme {
    return _theme;
  }

  void setAuthenticated(bool authenticated) {
    _authenticated = authenticated;
    notifyListeners();
  }

  void setTheme(String theme) {
    _theme = theme;
    notifyListeners();
  }
}
