import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/dependencies/theme_model.dart';

late SharedPreferences prefs;

class Settings extends StatefulWidget {
  final ThemeModel themeNotifier;

  Settings(this.themeNotifier);

  bool get isDarkEnabled => this.themeNotifier.isDark;

  @override
  SettingsWidgets createState() => SettingsWidgets();
}

class SettingsWidgets extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(padding: EdgeInsets.all(8.0),
        child: Row(
        mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        const Text("Dark Mode", style: TextStyle(fontSize: 24),),
        Switch.adaptive(
            value: widget.isDarkEnabled,
            activeColor: Colors.blue,
            dragStartBehavior: DragStartBehavior.start,
            onChanged: (newValue) {
              setState(() {
                widget.themeNotifier.isDark
                    ? widget.themeNotifier.isDark = false
                    : widget.themeNotifier.isDark = true;
              });
            })
      ]),)
    );
  }
}
