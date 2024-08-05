import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color.fromARGB(255, 182, 200, 226),
    primary: Color.fromARGB(255, 226, 233, 243),
    secondary: Color.fromARGB(255, 111, 147, 195),
    tertiary: Color.fromARGB(255, 30, 48, 72),
    inversePrimary: Color.fromARGB(255, 24, 38, 58)
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Color.fromARGB(255, 226, 233, 243),
    backgroundColor: Color.fromARGB(255, 66, 106, 158)
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color.fromARGB(255, 140, 169, 207)
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color.fromARGB(255, 18, 29, 43),
    primary: Color.fromARGB(255, 24, 38, 58),
    secondary: Color.fromARGB(255, 82, 126, 183),
    tertiary: Color.fromARGB(255, 154, 179, 213),
    inversePrimary: Color.fromARGB(255, 226, 233, 243)
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Color.fromARGB(255, 226, 233, 243),
    backgroundColor: Color.fromARGB(255, 48, 77, 115)
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color.fromARGB(255, 60, 96, 144)
  )
);