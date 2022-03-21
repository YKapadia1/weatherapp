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

  static ThemeData light() 
  {
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

  static ThemeData dark() 
  {
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

  static TextStyle lightText() //The text style to be used when in light mode.
  //This is used when some widgets do not follow the TextTheme defined.
  {return const TextStyle(color: Colors.black,);}

  static TextStyle darkText() //The text style to be used when in dark mode.
  //This is used when some widgets do not follow the TextTheme defined.
  {return const TextStyle(color: Colors.white,);}

  static SnackBar defaultSnackBar(String snackBarText) //A snackbar that takes a string parameter that displays a message to the user at the bottom of the screen.
  //This was done to avoid repeating code.
  {
    return SnackBar(
      content: Text(snackBarText, style: darkText()),
      backgroundColor: Colors.black,
      duration: const Duration(seconds: 2),
    );
  }

  static Container dismissibleContainer() //A dismissible container that the user sees when they swipe to remove the Dismissible object.
  //This is done to avoid repeating code.
  {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: const Icon(Icons.delete_forever),
    );
  }

  static TextStyle weatherDetailsTextStyle(double textSize) 
  {return TextStyle(color: Colors.white, fontSize: textSize);}
  //The text style used only on the weather details screen.
}
