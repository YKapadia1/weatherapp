import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'send_request.dart';
import 'add_city.dart';
import 'package:sqflite/sqflite.dart';
import 'my_theme.dart';

const apiKey = '769abfc9-64d7-4050-8cd3-79aecfda4830';

var request = http.MultipartRequest(
    'GET', Uri.parse('http://api.airvisual.com/v2/countries?key=' + apiKey));

void main() {
  runApp(const MyApp());
}

var responseText = 'test';

var Theme = AppTheme.dark();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(),theme: Theme,);
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {},
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
              title: const Text('Home')),
          body: TabBarView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No cities added',
                      style: Theme.textTheme.headline4,
                    ),
                    Text(
                        'Tap the button in the bottom right to add a city and get started.',
                        style: Theme.textTheme.headline5),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No favourite cities',
                        style: Theme.textTheme.headline4),
                    Text('Long press on a city to add it to your favourites.',
                        style: Theme.textTheme.headline5),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Map resp = await fetchCountryData();
                resp.forEach((status, cityData) {
                  tempCountryMap = cityData;
                });
                for (int i = 0; i < 100; i++) {
                  Map listMap = tempCountryMap[i];
                  countryList.add(listMap.values.toString());
                  countryList[i] = countryList[i]
                      .replaceAll(RegExp(r"\p{P}", unicode: true), "");
                  stateList.clear();
                  stateList.add('null');
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddCityRoute()));
              },
              child: const Icon(Icons.add_location)),
        ));
  }
}
