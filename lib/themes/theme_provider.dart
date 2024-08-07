import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notise/themes/themes.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themePrefKey = 'themePref';
  
  static ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveThemePreference(themeData == darkMode);
    notifyListeners();
  }

  bool get isDarkMode => _themeData == darkMode;


  // Method for user darkMode toggle
  void toggleTheme() {
    themeData = (_themeData == lightMode) ? darkMode : lightMode;
  }

  // Load the theme preference
  static Future<void> loadThemePreference() async {
    final SharedPreferencesWithCache prefsWithCache = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{_themePrefKey}
      ),
    );

    final bool? isDarkMode = prefsWithCache.getBool(_themePrefKey);

    if (isDarkMode != null) {
      _themeData = isDarkMode ? darkMode : lightMode;
    }
  }

  // Save the theme preference
  Future<void> _saveThemePreference(bool isDarkMode) async {
    final SharedPreferencesWithCache prefsWithCache = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{_themePrefKey}
      ),
    );

    await prefsWithCache.setBool(_themePrefKey, isDarkMode);
  }
}
