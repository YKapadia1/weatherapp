import 'package:flutter/material.dart';
import 'package:weatherapp/settings_widgets.dart';
import 'package:weatherapp/theme_model.dart';
import 'drop_down.dart';

class SettingsRoute extends StatelessWidget {
  final ThemeModel themeNotifier;
  const SettingsRoute(this.themeNotifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Center(child: Settings(this.themeNotifier)));
  }
}
