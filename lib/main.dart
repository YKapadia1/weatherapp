import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/dependencies/db_handler.dart';
import 'package:weatherapp/dependencies/send_request.dart';
import 'package:weatherapp/screens/add_city.dart';
import 'package:weatherapp/screens/settings.dart';
import 'package:weatherapp/dependencies/my_theme.dart';
import 'package:weatherapp/dependencies/theme_model.dart';
import 'package:weatherapp/screens/weather_details.dart';

import 'entry_table_model.dart';

const apiKey = '769abfc9-64d7-4050-8cd3-79aecfda4830';

var tempCountryMap;
var tempStateMap;

const String NOT_CONNECTED = "You are not connected to the Internet.";
const String CITY_REMOVED = "City successfully removed.";
const String ADDED_FAV = "City added to favourites.";

var request = http.MultipartRequest(
    'GET', Uri.parse('http://api.airvisual.com/v2/countries?key=' + apiKey));

void main() {
  runApp(const MyApp());
}

Center noCities() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No cities added',
          style: TextStyle(fontSize: 34, color: Colors.grey),
        ),
        Text(
            'Tap the button in the bottom right to add a city and get started.',
            style: TextStyle(
              fontSize: 24,
            )),
      ],
    ),
  );
}

Center noFavCities() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('No favourite cities',
            style: TextStyle(fontSize: 34, color: Colors.grey)),
        Text('Long press on a city to add it to your favourites.',
            style: TextStyle(
              fontSize: 24,
            )),
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
  late AllCitiesDatabaseHandler allCitiesDBHandler;

  @override
  void initState() {
    super.initState();
    this.allCitiesDBHandler = AllCitiesDatabaseHandler();
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
                      ],
                    ),
                    title: const Text('Your Cities')),
                body: TabBarView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: this.allCitiesDBHandler.getUserCities(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Entry>> snapshot) {
                            if (snapshot.data?.length != null) {
                              if (snapshot.data?.length != 0) {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Dismissible(
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          color: Colors.red,
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Icon(Icons.delete_forever),
                                        ),
                                        key: ValueKey<int>(
                                            snapshot.data![index].id!),
                                        onDismissed:
                                            (DismissDirection direction) async {
                                          await this
                                              .allCitiesDBHandler
                                              .deleteUserCity(
                                                  snapshot.data![index].id!);
                                          setState(() {
                                            snapshot.data!
                                                .remove(snapshot.data![index]);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                    AppTheme.DefaultSnackBar(
                                                        CITY_REMOVED));
                                          });
                                        },
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WeatherDetailsRoute()));
                                          },
                                          onLongPress: () =>
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                      AppTheme.DefaultSnackBar(
                                                          ADDED_FAV)),
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
                                                snapshot
                                                    .data![index].countryName
                                                    .toString()),
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
                    noFavCities(),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      try {
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
                      } on SocketException catch (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            AppTheme.DefaultSnackBar(NOT_CONNECTED));
                      }
                    },
                    child: const Icon(Icons.add_location))));
      },
    );
  }
}
