import 'package:flutter/material.dart';

class WeatherDetailsRoute extends StatelessWidget {
  const WeatherDetailsRoute({key: Key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
              child: Icon(
            Icons.favorite,
            size: 26.0,
          )),
        )
      ]),
    );
  }
}
