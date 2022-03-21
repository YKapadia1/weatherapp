import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences 
{
  static const prefKey = "isDarkEnabled";

  setTheme(bool value) async 
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance(); //See what shared preference values there are.
    sharedPreferences.setBool(prefKey, value); //Update the key value pair that stores what the app theme should be.
  }

  getTheme() async 
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(prefKey) ?? false; //Get the value from the key value pair storing the app theme preference.
    //If nothing is returned, default to false, indicating the app theme should be light mode.
  }
}