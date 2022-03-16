import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'send_request.dart';
import 'add_city.dart';
import 'package:sqflite/sqflite.dart';
import 'my_theme.dart';
import 'settings.dart';
import 'theme_model.dart';

const apiKey = '769abfc9-64d7-4050-8cd3-79aecfda4830';

var tempCountryMap;
var tempStateMap;

var request = http.MultipartRequest(
    'GET', Uri.parse('http://api.airvisual.com/v2/countries?key=' + apiKey));

void main() {
  runApp(const MyApp());
}

var responseText = 'test';

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
            home: HomePage(),
            theme: themeNotifier.isDark ? AppTheme.dark() : AppTheme.light(),
          );
        }));
  }
}

class HomePage extends StatelessWidget {
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
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsRoute(themeNotifier),));
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
                  title: const Text('Home')),
              body: TabBarView(
                children: [
                  Center(
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
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No favourite cities',
                            style: TextStyle(fontSize: 34, color: Colors.grey)),
                        Text(
                            'Long press on a city to add it to your favourites.',
                            style: TextStyle(
                              fontSize: 24,
                            )),
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
      },
    );
  }
}
