import 'package:flutter/material.dart';
import 'package:weatherapp/dependencies/weather_icons.dart';
import 'package:weatherapp/dependencies/my_theme.dart';
import 'package:weatherapp/dependencies/my_theme.dart';

bool isFavourited = false;

class WeatherDetailsRoute extends StatelessWidget {
  const WeatherDetailsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
              onTap: () {
                if (isFavourited) {
                  isFavourited = false;
                  ScaffoldMessenger.of(context).showSnackBar(
                      AppTheme.DefaultSnackBar(
                          "City removed from favourites."));
                } else {
                  isFavourited = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                      AppTheme.DefaultSnackBar("City added to favourites."));
                }

                (context as Element).reassemble();
              },
              child: Icon(
                isFavourited ? Icons.favorite : Icons.favorite_outline,
                size: 26.0,
              )),
        )
      ]),
      body: Center(child: testIcon),
    );
  }
}
