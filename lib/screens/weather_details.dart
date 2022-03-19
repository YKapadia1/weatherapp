import 'package:flutter/material.dart';
import 'package:weatherapp/dependencies/send_request.dart';
import 'package:weatherapp/dependencies/my_theme.dart';
import 'package:weatherapp/dependencies/db_handler.dart';
import 'package:weatherapp/entry_table_model.dart';

const apiKey = '769abfc9-64d7-4050-8cd3-79aecfda4830';

const iconDir = "image_assets/";
const backgroundDir = "image_assets/background_";

class WeatherDetailsRoute extends StatelessWidget {
  WeatherDetailsRoute(
      this.userCity, {Key? key}) : super(key: key);

  late Entry userCity;
  late DatabaseHandler dbHandler;

  Future<Map> getWeather() async 
  {
    final jsonMap = await fetchWeatherData(userCity.cityName, userCity.stateName, userCity.countryName);
    Map weatherMap = jsonMap['current']['weather'];
    return weatherMap;
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
        appBar: AppBar(actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
                onTap: () 
                {
                  if (userCity.isFavourite == 1) 
                  {
                    userCity.isFavourite = 0;
                    dbHandler.setFavCity(userCity, 0);
                    ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar("City removed from favourites."));
                  } 
                  else 
                  {
                    userCity.isFavourite = 1;
                    dbHandler.setFavCity(userCity, 1);
                    ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar("City added to favourites."));
                  }
                  (context as Element).reassemble();
                },
                child: Icon(
                  (userCity.isFavourite == 1) ? Icons.favorite : Icons.favorite_outline,
                  size:
                      26.0, //Displays a favourites icon or outlined favourites icon.
                  //This depends on if the city the user is viewing the weather for has been favourited.
                )),
          )
        ]),
        body: FutureBuilder(
          future: getWeather(),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) 
          {
            if (snapshot.hasData) 
            {
              var iconPath = iconDir + snapshot.data!['ic'].toString() + ".png";
              var weatherIcon = Image.asset(iconPath,width: 100,height: 100,);
              var backgroundPath = backgroundDir + snapshot.data!['ic'].toString() + ".jpg";
              var weatherBackground = AssetImage(backgroundPath);
              return Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: weatherBackground, fit: BoxFit.cover)),
                //The background image will change depending on the weather in the city. For example, if it is sunny, it will show a clear blue sky.
                //If it is cloudy, the background image will be clouds.
                child: Column(
                  children: <Widget>[
                    Text(userCity.cityName.toString(), style: AppTheme.weatherDetailsTextStyle(34)),
                    Text(userCity.stateName.toString() + ", " + userCity.countryName.toString(), style: AppTheme.weatherDetailsTextStyle(24)),
                    weatherIcon,
                    RichText(
                        text: TextSpan(
                            style: AppTheme.weatherDetailsTextStyle(48),
                            children: [
                          TextSpan(text: snapshot.data!['tp'].toString()),
                          WidgetSpan(
                              child: Transform.translate(
                                  offset: const Offset(0.0, -28.0),
                                  child: Text("o", style: AppTheme.weatherDetailsTextStyle(24)))),
                          TextSpan(text: "C",style: AppTheme.weatherDetailsTextStyle(48))
                        ]))
                  ],
                ),
              );
            } 
            else 
            {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
