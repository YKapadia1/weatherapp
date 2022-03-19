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

const String NOT_CONNECTED = "You are not connected to the Internet.";
const String CITY_REMOVED = "City successfully removed.";
const String ADDED_FAV = "City added to favourites.";
const String REMOVED_FAV = "City removed from favourites.";
//Strings that will be passed into the default SnackBar function to display different messages to the user.

var request = http.MultipartRequest('GET', Uri.parse('http://api.airvisual.com/v2/countries?key=' + apiKey));
//The API request to make to fetch all available cities. This will be called every time the user wants to add a city.




void main() {runApp(const MyApp());}




Center noCities() //This function will be called if the user does not have any cities added.
{
  return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: 
      [
        Text('No cities added',style: TextStyle(fontSize: 34, color: Colors.grey),),
        Text('Tap the button in the bottom right to add a city and get started.',style: TextStyle(fontSize: 24,)),
      ],
    ),
  );
}

Center noFavCities() //This function will be called if the user does not have any favourite cities.
{
  return Center(child: Column(mainAxisAlignment: MainAxisAlignment.start,
      children: 
      [
        Text('No favourite cities',style: TextStyle(fontSize: 34, color: Colors.grey)),
        Text('Long press on a city to add it to your favourites.',style: TextStyle( fontSize: 24,)),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(
            builder: (context, ThemeModel themeNotifier, child) {
          return MaterialApp(
            home: HomePageState(),
            theme: themeNotifier.isDark ? AppTheme.dark() : AppTheme.light(),
          );
        }));
  }
}

class HomePageState extends StatefulWidget {
  @override
  HomePage createState() => HomePage();
}

class HomePage extends State {
  late DatabaseHandler DBHandler;

  @override
  void initState() {
    super.initState();
    this.DBHandler = DatabaseHandler(); //Initialise an instance of the DatabaseHandler so the database can be queried.
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
        return DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                    actions: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    SettingsRoute(themeNotifier),
                              ));
                            },
                            child: Icon(
                              Icons.settings,
                              size: 26.0,
                            ),
                          )),
                    ],
                    bottom: const TabBar(
                      tabs: [
                        Tab(text: 'All'),
                        Tab(text: 'Favourites'),
                        //Make 2 tabs, one for all cities the user has added, and one for their favourite cities.
                      ],
                    ),
                    title: const Text('Your Cities')),
                body: TabBarView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FutureBuilder( //This future builder creates a card ListView based on the amount of entries getUserCities returns.
                          future: this.DBHandler.getUserCities(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Entry>> snapshot) {
                            if (snapshot.data?.length != null) {
                              if (snapshot.data?.length != 0) {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.length,
                                  itemBuilder:(BuildContext context, int index) 
                                  {
                                    return Dismissible(direction: DismissDirection.endToStart,background:AppTheme.DismissibleContainer(),
                                        key: ValueKey<int>(snapshot.data![index].id!),
                                        onDismissed:(DismissDirection direction) async 
                                        {
                                          await this.DBHandler.deleteUserCity(snapshot.data![index].id!);
                                          setState(() 
                                          {
                                            snapshot.data!.remove(snapshot.data![index]);
                                            ScaffoldMessenger.of(context).showSnackBar(AppTheme.DefaultSnackBar(CITY_REMOVED));
                                          });
                                        },
                                        child: GestureDetector(
                                          onTap: () 
                                          {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                                            WeatherDetailsRoute(snapshot.data![index].cityName,snapshot.data![index].stateName,snapshot.data![index].countryName,snapshot.data![index].isFavourite)));
                                          },
                                          onLongPress: () {
                                            if (snapshot.data![index].isFavourite == 0) //If the city that has been long pressed is not favourited...
                                            {
                                              this.DBHandler.setFavCity(snapshot.data![index], 1); //Update the entry's isFavourited column to state that the city is favourited.
                                              ScaffoldMessenger.of(context).showSnackBar(AppTheme.DefaultSnackBar(ADDED_FAV));
                                              //Show a snackbar to the user informing them the city has been added to their favourites.
                                              setState(() {}); //Refresh the widgets on screen.
                                            } 
                                            else //If the city is favourited...
                                            {
                                              this.DBHandler.setFavCity(snapshot.data![index], 0); //Update the entry's isFavourited column to state that the city 
                                              //is no longer favourited.
                                              ScaffoldMessenger.of(context).showSnackBar(AppTheme.DefaultSnackBar(REMOVED_FAV));
                                               //Show a snackbar to the user informing them the city has been removed from their favourites.
                                              setState(() {}); //Refresh the widgets on screen.
                                            }
                                          },
                                          child: Card(child: ListTile(
                                            contentPadding: EdgeInsets.all(8.0),
                                            title: Text(snapshot.data![index].cityName.toString()),
                                            subtitle: Text(snapshot.data![index].stateName.toString() + ", " + snapshot.data![index].countryName.toString()),
                                          )),
                                        ));
                                  },
                                );
                              } else {
                                return noCities();
                              }
                            } else {
                              return noCities();
                            }
                          },
                        )
                      ],
                    ),
                    FutureBuilder(
                      future: this.DBHandler.getFavUserCities(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Entry>> snapshot) {
                        if (snapshot.data?.length != null) {
                          if (snapshot.data?.length != 0) {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Dismissible(
                                    direction: DismissDirection.endToStart,
                                    background: AppTheme.DismissibleContainer(),
                                    key: UniqueKey(),
                                    onDismissed:
                                        (DismissDirection direction) async {
                                      this.DBHandler.setFavCity(
                                          snapshot.data![index], 0);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              AppTheme.DefaultSnackBar(
                                                  REMOVED_FAV));
                                      setState(() {});
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WeatherDetailsRoute
                                                    (snapshot.data![index].cityName,snapshot.data![index].stateName,snapshot.data![index].countryName,snapshot.data![index].isFavourite)));
                                      },
                                      child: Card(
                                          child: ListTile(
                                        contentPadding: EdgeInsets.all(8.0),
                                        title: Text(snapshot
                                            .data![index].cityName
                                            .toString()),
                                        subtitle: Text(snapshot
                                                .data![index].stateName
                                                .toString() +
                                            ", " +
                                            snapshot.data![index].countryName
                                                .toString()),
                                      )),
                                    ));
                              },
                            );
                          } else {
                            return noFavCities();
                          }
                        } else {
                          return noFavCities();
                        }
                      },
                    )
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                    onPressed: () async 
                    {
                      try { //When the button is pressed, try to lookup the address of google.com. 
                            //If successful, then get the list of countries via an API call, and navigate to the add city screen.
                        final isConnected =
                            await InternetAddress.lookup('google.com');
                        if (isConnected.isNotEmpty &&
                            isConnected[0].rawAddress.isNotEmpty) {
                          Map resp = await fetchCountryData();
                          resp.forEach((status, cityData) {
                            tempCountryMap = cityData;
                          });
                          for (int i = 0; i < 100; i++) {
                            Map listMap = tempCountryMap[i];
                            countryList.add(listMap.values.toString());
                            countryList[i] = countryList[i].replaceAll(
                                RegExp(r"\p{P}", unicode: true), "");
                            stateList.clear();
                            stateList.add('null');
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddCityRoute(),
                              )).then((value) {
                            (context as Element).reassemble();
                          });
                        }
                      } 
                      on SocketException catch (_) //If the internet address lookup threw an exception, i.e there is no connection.
                      {
                        ScaffoldMessenger.of(context).showSnackBar(AppTheme.DefaultSnackBar(NOT_CONNECTED));
                            //Only show a snackbar to the user indicating that there is no internet connection, and do not navigate to another screen.
                      }
                    },
                    child: const Icon(Icons.add_location))));
                    //The FloatingActionButton will have an icon that represents adding a location.
      },
    );
  }
}
