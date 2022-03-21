import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/dependencies/theme_model.dart';

late SharedPreferences prefs;

class Settings extends StatefulWidget 
{
  final ThemeModel themeNotifier;
  const Settings(this.themeNotifier);
  bool get isDarkEnabled => themeNotifier.isDark;

  @override
  SettingsWidgets createState() => SettingsWidgets();
}

class SettingsWidgets extends State<Settings> 
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: Container(padding: const EdgeInsets.all(8.0),
        child: Row(
        mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //Create a container with a Row child as the widgets.
        children: <Widget>[
        const Text("Dark Mode", style: TextStyle(fontSize: 24),), //Inside the Row child, have a text label, as well as a switch.
        Switch.adaptive( //The switch controls the theme preference. If its set to off, then the app theme will be light mode.
        //If set to on, then the app theme will be dark mode.
            value: widget.isDarkEnabled,
            activeColor: Colors.blue, //The color of the switch when it is active.
            dragStartBehavior: DragStartBehavior.start, //How to animate the switch.
            onChanged: (newValue) //If the switch is pressed on...
            {
              setState(() 
              {
                //Get the value of the isDark bool. If its true, set to false. If not, set to true.
                widget.themeNotifier.isDark ? widget.themeNotifier.isDark = false : widget.themeNotifier.isDark = true;
              });
            })
      ]),)
    );
  }
}
