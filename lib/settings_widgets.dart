import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_model.dart';

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
      body: Row(children: <Widget>[
        const Text("Dark Mode"),
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
      ]),
    );
  }
}
