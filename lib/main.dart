import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/dependencies/db_handler.dart';
import 'package:weatherapp/dependencies/send_request.dart';
import 'package:weatherapp/dependencies/my_theme.dart';
import 'package:weatherapp/dependencies/theme_model.dart';
import 'package:weatherapp/screens/add_city.dart';
import 'package:weatherapp/screens/settings.dart';
import 'package:weatherapp/screens/weather_details.dart';
import 'entry_table_model.dart';
//Import all packages/dependencies needed.

const apiKey = '769abfc9-64d7-4050-8cd3-79aecfda4830';

var tempCountryMap;
var tempStateMap;

const String notConnected = "You are not connected to the Internet.";
const String cityRemoved = "City successfully removed.";
const String addedFav = "City added to favourites.";
const String removedFav = "City removed from favourites.";
//Strings that will be passed into the default SnackBar function to display different messages to the user.

var request = http.MultipartRequest('GET', Uri.parse('http://api.airvisual.com/v2/countries?key=' + apiKey));
//The API request to make to fetch all available cities. This will be called every time the user wants to add a city.

void main() {runApp(const MyApp());}

Center
    noCities() //This function will be called if the user does not have any cities added.
{
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const 
      [
        Text('No cities added', style: TextStyle(fontSize: 34, color: Colors.grey),),
        Text('Tap the button in the bottom right to add a city and get started.',style: TextStyle(fontSize: 24,)),
      ],
    ),
  );
}

Center
    noFavCities() //This function will be called if the user does not have any favourite cities.
{
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const 
      [
        Text('No favourite cities',style: TextStyle(fontSize: 34, color: Colors.grey)),
        Text('Long press on a city to add it to your favourites.', style: TextStyle(fontSize: 24,)),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) 
  {
    return ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(builder: (context, ThemeModel themeNotifier, child) 
        {
          return MaterialApp(home: const HomePageState(),theme: themeNotifier.isDark ? AppTheme.dark() : AppTheme.light(),);
        }));
  }
}

class HomePageState extends StatefulWidget 
{
  const HomePageState({Key? key}) : super(key: key);
  @override
  HomePage createState() => HomePage();
}

class HomePage extends State 
{
  late DatabaseHandler dbHandler;

  @override
  void initState() 
  {
    super.initState();
    dbHandler = DatabaseHandler(); //Initialise an instance of the DatabaseHandler so the database can be queried.
  }

  @override
  Widget build(BuildContext context) 
  {
    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) 
      {
        return DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                    actions: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: GestureDetector(
                            onTap: () 
                            {
                              Navigator.of(context).push(MaterialPageRoute( builder: (context) => SettingsRoute(themeNotifier),));
                            },
                            child: const Icon(Icons.settings,size: 26.0,),
                          )),
                    ],
                    bottom: const TabBar(
                      tabs: 
                      [
                        Tab(text: 'All'),
                        Tab(text: 'Favourites'),
                        //Make 2 tabs, one for all cities the user has added, and one for their favourite cities.
                      ],
                    ),
                    title: const Text('Your Cities')), //The starting page will have a title called 'Your Cities'.
                body: TabBarView(
                  children: [
                    Column(mainAxisAlignment: MainAxisAlignment.start,
                      children: 
                      [
                        FutureBuilder(
                          //This future builder creates a card ListView based on the amount of entries getUserCities returns.
                          future: dbHandler.getUserCities(),
                          builder: (BuildContext context, AsyncSnapshot<List<UserCityDetails>> snapshot) 
                          {
                            if (snapshot.data?.length != null) //If the data length is not null...
                            {
                              if (snapshot.data?.length != 0) //If the data length is not zero...
                              //Two if statements are necessary, as snapshot.data?.length may not be null but it may be empty.
                              //For some reason, flutter/dart do not consider empty to be the same as null.
                              {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Dismissible(
                                        direction: DismissDirection.endToStart,
                                        background:AppTheme.dismissibleContainer(),
                                        key: ValueKey<int>(snapshot.data![index].id!),
                                        onDismissed: (DismissDirection direction) async //If the user dismisses the entry...
                                        {
                                          await dbHandler.deleteUserCity(snapshot.data![index].id!);
                                          setState(() 
                                          {
                                            snapshot.data!.remove(snapshot.data![index]);
                                            ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(cityRemoved));
                                          });
                                        },
                                        child: GestureDetector(
                                          onTap: () async 
                                          { 
                                            try 
                                            {
                                              //When the button is pressed, try to lookup the address of google.com.
                                              //If successful, then navigate to the weather details screen, passing in the entire array of city details.
                                              final isConnected = await InternetAddress.lookup('google.com');
                                              if (isConnected.isNotEmpty && isConnected[0].rawAddress.isNotEmpty) 
                                              {
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WeatherDetailsRoute(snapshot.data![index]))).then((value)
                                                {
                                                  setState(() {});
                                                });
                                              }
                                            } 
                                            on SocketException catch (_)  //If the internet address lookup threw an exception, i.e there is no connection...
                                            {
                                              ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(notConnected));
                                              //Only show a snackbar to the user indicating that there is no internet connection, and do not navigate to another screen.
                                            }
                                          },
                                          onLongPress: () {
                                            if (snapshot.data![index].isFavourite == 0) //If the city that has been long pressed is not favourited...
                                            {
                                              dbHandler.setFavCity(snapshot.data![index],1); //Update the entry's isFavourited column to state that the city is favourited.
                                              ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(addedFav));
                                              //Show a snackbar to the user informing them the city has been added to their favourites.
                                              //Because the FutureBuilder for the favourites list is constantly being executed, this will be shown as soon as
                                              //the user adds a city to their favourites list.
                                              setState(
                                                  () {}); //Refresh the widgets on screen.
                                            } else //If the city is already favourited...
                                            {
                                              dbHandler.setFavCity(snapshot.data![index], 0); 
                                              //Update the entry's isFavourited column to state that the city
                                              //is no longer favourited.
                                              ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(removedFav));
                                              //Show a snackbar to the user informing them the city has been removed from their favourites.
                                              setState(
                                                  () {}); //Refresh the widgets on screen.
                                            }
                                          },
                                          child: Card(
                                            child: ListTile(
                                            contentPadding: const EdgeInsets.all(8.0),
                                            title: Text(snapshot.data![index].cityName.toString()),
                                            subtitle: Text(snapshot.data![index].stateName.toString() + ", " + snapshot.data![index].countryName.toString()),
                                          )),
                                        ));
                                  },
                                );
                              } 
                              else //If the length was zero, indicating the list was empty...
                              {
                                return noCities(); //Show to the user that there are no cities.
                              }
                            } 
                            else //If the length was null...
                            {
                              return noCities();
                            }
                          },
                        )
                      ],
                    ),
                    //This future builder creates a card ListView based on the amount of entries getFavUserCities returns.
                    //getFavUserCities returns those entries where isFavourite is 1, indicating the user has favourited those cities.
                    FutureBuilder(
                      future: dbHandler.getFavUserCities(),
                      builder: (BuildContext context, AsyncSnapshot<List<UserCityDetails>> snapshot) {
                        if (snapshot.data?.length != null) 
                        {
                          if (snapshot.data?.length != 0) 
                          {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) 
                              {
                                return Dismissible(
                                    direction: DismissDirection.endToStart,
                                    background: AppTheme.dismissibleContainer(),
                                    key: UniqueKey(), //A unique key is used instead of ValueKey, otherwise when the dismissible is dismissed, the data is not removed.
                                                      //Because the data does not end up getting removed, it causes an exception.
                                    onDismissed: (DismissDirection direction) async 
                                    {
                                      dbHandler.setFavCity(snapshot.data![index], 0);
                                      ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(removedFav));
                                      setState(() {});
                                    },
                                    child: GestureDetector(
                                      onTap: () async
                                      {
                                        try 
                                            {
                                              //When the button is pressed, try to lookup the address of google.com.
                                              //If successful, then navigate to the weather details screen, passing in the entire array of city details.
                                              final isConnected = await InternetAddress.lookup('google.com');
                                              if (isConnected.isNotEmpty && isConnected[0].rawAddress.isNotEmpty) 
                                              {
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WeatherDetailsRoute(snapshot.data![index]))).then((value)
                                                {
                                                  setState(() {});
                                                   //Once the user has exited the screen, refresh the main screen.
                                                });
                                              }
                                            } 
                                            on SocketException catch (_)  //If the internet address lookup threw an exception, i.e there is no connection...
                                            {
                                              ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(notConnected));
                                              //Only show a snackbar to the user indicating that there is no internet connection, and do not navigate to another screen.
                                            }
                                       
                                      },
                                      child: Card(
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(8.0),
                                          title: Text(snapshot.data![index].cityName.toString()),
                                          subtitle: Text(snapshot.data![index].stateName.toString() + ", " +snapshot.data![index].countryName.toString()),
                                          //In the listview body, create a list tile with the name of the city, as well as the state and country of the city.
                                      )),
                                    ));
                              },
                            );
                          } 
                          else 
                          {
                            return noFavCities();
                            //If the snapshot data length was zero, display on screen that there are no favourite cities.
                          }
                        } 
                        else 
                        {
                          return noFavCities();
                          //If the snapshot data length was null, display on screen that there are no favourite cities.
                        }
                      },
                    )
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                    onPressed: () async 
                    {
                      try 
                      {
                        //When the button is pressed, try to lookup the address of google.com.
                        //If successful, then get the list of countries via an API call, and navigate to the add city screen.
                        final isConnected = await InternetAddress.lookup('google.com');
                        if (isConnected.isNotEmpty && isConnected[0].rawAddress.isNotEmpty) 
                        {
                          Map resp = await fetchCountryData();
                          resp.forEach((status, cityData) {tempCountryMap = cityData;});
                          for (int i = 0; i < 100; i++) //For the 100 countries that are in the list...
                          {
                            Map listMap = tempCountryMap[i]; //Store the country in a temporary map.
                            countryList.add(listMap.values.toString()); //Add the value stored in the temporary map into another list.
                            countryList[i] = countryList[i].replaceAll(RegExp(r"\p{P}", unicode: true), ""); //Remove any brackets that may be in the string.
                            stateList.clear(); //Make sure the state list is empty to prevent the statelist drop down from showing any values.
                            stateList.add('null'); //As well as this, add the text value 'null' so that the code in the add city screen can act accordingly.
                          }
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const AddCityRoute(),)).then((value) //Go to the add city screen, then...
                          {
                            (context as Element).reassemble(); //Refresh the screen.
                          });
                        }
                      } 
                      on SocketException catch (_) //If the internet address lookup threw an exception, i.e there is no connection...
                      {
                        ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(notConnected));
                        //Only show a snackbar to the user indicating that there is no internet connection, and do not navigate to another screen.
                      }
                    },
                    child: const Icon(Icons.add_location))));
                     //The FloatingActionButton will have an icon that represents adding a location.
      },
    );
  }
}
