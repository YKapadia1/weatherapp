import 'package:flutter/material.dart';
import 'package:weatherapp/screens/settings_widgets.dart';
import 'package:weatherapp/dependencies/theme_model.dart';

class SettingsRoute extends StatelessWidget {
  final ThemeModel themeNotifier;
  const SettingsRoute(this.themeNotifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings')),
          body: Center(child: Settings(themeNotifier)));
    //When the app navigates to the settings page, display an appBar with the text "Settings".
    //In the body, call the Settings StatefulWidget with the ThemeModel as the parameter.
  }
}
