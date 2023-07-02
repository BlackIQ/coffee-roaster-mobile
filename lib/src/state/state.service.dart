import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
// language
  Locale _locale = const Locale('en', '');
  Locale get getLocale => _locale;
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

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
  Brightness _theme = Brightness.light;
  Brightness get getTheme => _theme;
  void setTheme(Brightness theme) {
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
