import 'package:flutter/material.dart';
import 'package:weatherapp/dependencies/send_request.dart';
import 'package:weatherapp/dependencies/my_theme.dart';
import 'package:weatherapp/dependencies/db_handler.dart';
import 'package:weatherapp/user_city_table_model.dart';

const apiKey = '769abfc9-64d7-4050-8cd3-79aecfda4830';

const iconDir = "assets/"; //The directory of the weather icons.
const backgroundDir = "assets/background_"; //The directory of the background images.

class WeatherDetailsRoute extends StatelessWidget 
{
  WeatherDetailsRoute(this.userCity, {Key? key}) : super(key: key);
  //The weather details constructor takes a variable with the data type of Entry. Entry is the data model I am using to store the user's cities.

  final UserCityDetails userCity;
  final DatabaseHandler dbHandler = DatabaseHandler();
  //Declare these variables as late, as they will be initialised later on.

  Future<Map> getWeather() async //Gets the weather data using the Entry variable supplied to WeatherDetailsRoute.
  //Depending on what city the user has requested the weather for, the return will be different.
  {
    final jsonMap = await fetchWeatherData(userCity.cityName, userCity.stateName, userCity.countryName); //Call on the API to get the weather data, and store the response
    //in a final called jsonMap.
    Map weatherMap = jsonMap['current']['weather']; //Get the data that is in 'current'. Within that, get the data that is in 'weather'. Store it in a new Map called weatherMap.
    return weatherMap; //Return weatherMap to the caller.
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
        appBar: AppBar(actions: <Widget>[ //Return an appBar with the following...
          Padding(
            padding: const EdgeInsets.only(right: 20.0), //Align whatever is going to be in the appBar to the right.
            child: GestureDetector( //Listen for any gestures the user may perform on this object...
                onTap: () //If the user has tapped on the object once...
                {
                  if (userCity.isFavourite == 1) //If the city is already favourited...
                  {
                    userCity.isFavourite = 0; //Set the favourite int to 0.
                    dbHandler.setFavCity(userCity, 0); //Tell the DB to set the isFavourite column on this city to 0.
                    ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar("City removed from favourites."));
                    //Display a snackbar informing the user the city has been removed from the favourites.
                  } 
                  else 
                  {
                    userCity.isFavourite = 1; //Set the favourite int to 1.
                    dbHandler.setFavCity(userCity, 1);  //Tell the DB to set the isFavourite column on this city to 1.
                    ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar("City added to favourites."));
                    //Display a snackbar informing the user the city has been added to the favourites.
                  }
                  (context as Element).reassemble(); //Refresh the screen.
                },
                child: Icon(
                  (userCity.isFavourite == 1) ? Icons.favorite : Icons.favorite_outline,size: 26.0)),
                  //Displays a favourites icon or outlined favourites icon.
                  //This depends on if the city the user is viewing the weather for has been favourited.
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
              //These variables are determined by what icon code the API returns. For example, if the API returns icon code 01d, that means the icon will be sunny.
              //This also means the weatherBackground will display an image of a clear sky.
              return Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(image: DecorationImage(image: weatherBackground, fit: BoxFit.cover)),
                //The background image will change depending on the weather in the city. For example, if it is sunny, it will show a clear blue sky.
                //If it is cloudy, the background image will be clouds.
                child: Column(
                  children: <Widget>[
                    Text(userCity.cityName.toString(), style: AppTheme.weatherDetailsTextStyle(34)), //The name of the city.
                    Text(userCity.stateName.toString() + ", " + userCity.countryName.toString(), style: AppTheme.weatherDetailsTextStyle(24)),
                    //The name of the state and country combined together.
                    weatherIcon, //The weather icon. This will be different depending on what the API returns.
                    RichText( 
                    //This RichText widget combines multiple strings together, as well as lets me use superscripting to display the temperature properly.
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
            else //If getWeather has not returned anything yet...
            {
              return const Center(child: CircularProgressIndicator()); //Display a progress circle in the center.
            }
          },
        ));
  }
}
