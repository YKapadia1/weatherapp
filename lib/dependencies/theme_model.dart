import 'package:flutter/material.dart';
import 'theme_prefs.dart';

class ThemeModel extends ChangeNotifier {
  late bool _isDark;
  late ThemePreferences _preferences;
  bool get isDark => _isDark;

  ThemeModel() 
  {
    _isDark = false; //Initialise _isDark to false.
    _preferences = ThemePreferences();
    getPreferences(); //Get the current theme preference.
  }

  set isDark(bool value) //Sets the value which dictates what the app theme should be.
  {
    _isDark = value; //Set the value of _isDark to the value passed in.
    _preferences.setTheme(value); //Update the shared preferences value.
    notifyListeners(); //Notify all listeners what the app theme should be.
  }

  getPreferences() async //Get the saved theme preference.
  {
    _isDark = await _preferences.getTheme(); //Store the current theme preference in a boolean.
    notifyListeners(); //Notify all listeners what the app theme should be.
  }
}