import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFFC9900),
    ),
    primaryColor: Color(0xFFFC9900),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFFC9900),
      type: BottomNavigationBarType.fixed,
      elevation: 17.0,
      selectedItemColor: Colors.white,
      selectedIconTheme: IconThemeData(color: Colors.white),
      selectedLabelStyle: TextStyle(color: Colors.white),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 55,
      iconTheme: IconThemeData(
        color: Colors.grey,
      ),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
          fontSize: 32.0,
          fontFamily: 'Arial',
          color: Colors.grey[700],
          fontWeight: FontWeight.w600),
      bodyText1: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Arial',
          color: Colors.grey[600],
          fontWeight: FontWeight.w200),
      button: TextStyle(
          fontSize: 16.0, fontFamily: 'Arial', fontWeight: FontWeight.w200),
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFFF4F7FA),
    colorScheme: ColorScheme.light(
      primary: Color(0xFFFC9900),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 55,
      iconTheme: IconThemeData(
        color: Colors.grey,
      ),
    ),
    primaryColor: Color(0xFFFC9900),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFFC9900),
      type: BottomNavigationBarType.fixed,
      elevation: 17.0,
      unselectedIconTheme: IconThemeData(color: Colors.white),
      unselectedItemColor: Colors.white,
      unselectedLabelStyle: TextStyle(color: Colors.white),
      selectedItemColor: Colors.white,
      selectedIconTheme: IconThemeData(color: Colors.white),
      selectedLabelStyle: TextStyle(color: Colors.white),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
          fontSize: 32.0,
          fontFamily: 'Arial',
          color: Colors.grey[700],
          fontWeight: FontWeight.w600),
      bodyText1: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Arial',
          color: Colors.grey[600],
          fontWeight: FontWeight.w200),
      button: TextStyle(
          fontSize: 16.0, fontFamily: 'Arial', fontWeight: FontWeight.w200),
    ),
  );
}
