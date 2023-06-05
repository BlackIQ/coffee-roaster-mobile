import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _authenticated = false;

  bool get getAuthenticated {
    return _authenticated;
  }

  void setAuthenticated(bool authenticated) {
    _authenticated = authenticated;
    notifyListeners();
  }
}
