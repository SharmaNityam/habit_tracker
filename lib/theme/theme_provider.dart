import 'package:flutter/material.dart';
import 'light_mode.dart';
import 'dark_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //initially light theme
  ThemeData _themeData = lightMode;

  //get current theme
ThemeData get themeData => _themeData;

//is currernt theme dark?
bool get isDarkTheme => _themeData == darkMode;

//set theme
   void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
  //toggle theme
void toggleTheme(ThemeProvider themeProvider) {
  if (themeProvider.isDarkTheme) {
    themeProvider.setThemeData(lightMode);
  } else {
    themeProvider.setThemeData(darkMode);
  }
}
}
