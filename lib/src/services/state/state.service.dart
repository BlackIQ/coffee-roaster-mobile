import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  // Language
  Locale _locale = const Locale('en', '');
  Locale get getLocale => _locale;
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  // Authentication
  bool _authenticated = false;
  bool get getAuthenticated => _authenticated;
  void setAuthenticated(bool authenticated) {
    _authenticated = authenticated;
    notifyListeners();
  }

  // Guest
  bool _guest = false;
  bool get getGuest => _guest;
  void setGuest(bool guest) {
    _guest = guest;
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
  Brightness _theme = Brightness.light;
  Brightness get getTheme => _theme;
  void setTheme(Brightness theme) {
    _theme = theme;
    notifyListeners();
  }

  // Theme
  MaterialColor _themeColor = Colors.blue;
  MaterialColor get getThemeColor => _themeColor;
  void setThemeColor(MaterialColor themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }

  // Bluetooth device
  BluetoothDevice? _ble;
  BluetoothDevice? get getBle => _ble;
  void setBle(BluetoothDevice ble) {
    _ble = ble;
    notifyListeners();
  }

  void unsetBle() {
    _ble = null;
    notifyListeners();
  }

  // Bluetooth device
  String _bleId = "";
  String get getBleId => _bleId;
  void setBleId(String bleId) {
    _bleId = bleId;
    notifyListeners();
  }
}
