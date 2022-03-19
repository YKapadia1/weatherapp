import 'package:flutter/material.dart';
import 'package:weatherapp/dependencies/send_request.dart';
import 'package:weatherapp/dependencies/my_theme.dart';

const apiKey = '769abfc9-64d7-4050-8cd3-79aecfda4830';

const ICON_DIR = "image_assets/";
const BACKGROUND_DIR = "image_assets/background_";

class WeatherDetailsRoute extends StatelessWidget {
  WeatherDetailsRoute(
      this.cityName, this.stateName, this.countryName, this.isFavourite);

  late String? cityName;
  late String? stateName;
  late String? countryName;
  late int isFavourite;

  Future<Map> getWeather() async {
    final jsonMap = await fetchWeatherData(cityName, stateName, countryName);
    Map weatherMap = jsonMap['current']['weather'];
    return weatherMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
                onTap: () {
                  if (this.isFavourite == 1) 
                  {
                    isFavourite = 0;
                    ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar( "City removed from favourites."));
                  } 
                  else 
                  {
                    isFavourite = 1;
                    ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar("City added to favourites."));
                  }
                  (context as Element).reassemble();
                },
                child: Icon(
                  (this.isFavourite == 1) ? Icons.favorite : Icons.favorite_outline,
                  size: 26.0,
                )),
          )
        ]),
        body: FutureBuilder(
          future: getWeather(),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
            if (snapshot.hasData) {
              var iconPath = ICON_DIR + snapshot.data!['ic'].toString() + ".png";
              var weather_icon = Image.asset(
                iconPath,
                width: 100,
                height: 100,
              );
              var backgroundPath = BACKGROUND_DIR + snapshot.data!['ic'].toString() + ".jpg";
              var weather_background = AssetImage(backgroundPath);

              return Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    image: DecorationImage(image: weather_background, fit: BoxFit.cover)), 
                    //The background image will change depending on the weather in the city. For example, if it is sunny, it will show a clear blue sky.
                    //If it is cloudy, the background image will be clouds.
                child: Column(
                  children: <Widget>[
                    Text(
                      this.cityName.toString(),
                      style: AppTheme.weatherDetailsTextStyle(34),
                    ),
                    Text(
                      this.stateName.toString() +  ", " + this.countryName.toString(),
                      style: AppTheme.weatherDetailsTextStyle(24),
                    ),
                    weather_icon,
                    RichText(
                        text: TextSpan(
                            style: AppTheme.weatherDetailsTextStyle(48),
                            children: [
                          TextSpan(text: snapshot.data!['tp'].toString()),
                          WidgetSpan(
                            child: Transform.translate(
                            offset: const Offset(0.0, -28.0),
                            child: Text("o",style: AppTheme.weatherDetailsTextStyle(24)),
                          )),
                          TextSpan(
                              text: "C",
                              style: AppTheme.weatherDetailsTextStyle(48))
                        ]))
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
