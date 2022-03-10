//import 'dart:html';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const apiKey = '769abfc9-64d7-4050-8cd3-79aecfda4830';

var request = http.MultipartRequest(
    'GET', Uri.parse('http://api.airvisual.com/v2/countries?key=' + apiKey));

void main() {
  runApp(const MyApp());
}

var responseText = 'test';

void getResponse() async {
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
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
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Text(
                        'Tap the button in the bottom right to add a city and get started.',
                        style: Theme.of(context).textTheme.headline5),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No favourite cities',
                        style: Theme.of(context).textTheme.headline4),
                    Text('Long press on a city to add it to your favourites.',
                        style: Theme.of(context).textTheme.headline5),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddCityRoute()));
            },
            child: const Icon(Icons.add_location),
          ),
        ));
  }
}

class DropDown extends StatefulWidget {
  @override
  DropDownWidget createState() => DropDownWidget();
}

class DropDownWidget extends State {
  String? SelectedDropDownItem = 'Country One';
  List<String> spinnerItems = [
    'Country One',
    'Country Two',
    'Country Three',
    'Country Four',
    'Country Five'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: <Widget>[
        DropdownButton<String>(
          value: SelectedDropDownItem,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          underline: Container(
            height: 2,
            color: Colors.black,
          ),
          onChanged: (String? data) {
            setState(() {
              SelectedDropDownItem = data;
            });
          },
          items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Text('Selected Item = ' '$SelectedDropDownItem',
            style: TextStyle(fontSize: 22, color: Colors.black)),
      ],
    )));
  }
}

class AddCityRoute extends StatelessWidget {
  const AddCityRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a city...'),
      ),
      body: DropDown(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getResponse();
        },
        child: const Icon(Icons.web),
      ),
    );
  }
}
