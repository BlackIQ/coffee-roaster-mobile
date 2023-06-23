import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  // Authentication
  bool _authenticated = true;
  bool get getAuthenticated => _authenticated;
  void setAuthenticated(bool authenticated) {
    _authenticated = authenticated;
    notifyListeners();
  }

  // Token
  String _token = '';
  String get getToken => _token;
  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  // Theme
  String _theme = 'light';
  String get getTheme => _theme;
  void setTheme(String theme) {
    _theme = theme;
    notifyListeners();
  }

  // Bluetooth device
  BluetoothDevice? _ble;
  BluetoothDevice? get getBle => _ble;
  void setBle(BluetoothDevice ble) {
    _ble = ble;
    notifyListeners();
  }
}
