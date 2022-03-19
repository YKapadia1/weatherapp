import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: Colors.black,
        wordSpacing: 0.5),
    headline4: GoogleFonts.openSans(
        fontWeight: FontWeight.normal,
        fontSize: 34,
        color: Colors.grey,
        wordSpacing: 0.25),
    headline5: GoogleFonts.openSans(
        fontWeight: FontWeight.normal,
        fontSize: 24,
        color: Colors.black,
        wordSpacing: 0),
  );
  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: Colors.white,
        wordSpacing: 0.5),
    headline4: GoogleFonts.openSans(
        fontWeight: FontWeight.normal,
        fontSize: 34,
        color: Colors.grey,
        wordSpacing: 0.25),
    headline5: GoogleFonts.openSans(
        fontWeight: FontWeight.normal,
        fontSize: 24,
        color: Colors.white,
        wordSpacing: 0),
  );

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
      ),
      textTheme: lightTextTheme,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
      ),
      textTheme: darkTextTheme,
    );
  }

  static TextStyle lightText() {
    return TextStyle(
      color: Colors.black,
    );
  }

  static TextStyle darkText() {
    return TextStyle(
      color: Colors.white,
    );
  }

  static SnackBar DefaultSnackBar(String snackBarText) {
    return SnackBar(
      content: Text(snackBarText, style: darkText()),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 2),
    );
  }

  static Container DismissibleContainer() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Icon(Icons.delete_forever),
    );
  }

  static TextStyle WeatherDetailsTextStyle(double textSize) {
    return TextStyle(color: Colors.white, fontSize: textSize);
  }
}
