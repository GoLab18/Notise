import 'package:flutter/material.dart';
import 'package:notise/themes/themes.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;

    notifyListeners();
  }

  bool get isDarkMode => _themeData == darkMode;
  

// Method for user darkMode toggle
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}