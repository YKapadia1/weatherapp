import 'dart:io';
import 'package:flutter/material.dart';
import 'package:weatherapp/dependencies/my_theme.dart';
import '../entry_table_model.dart';
import 'add_city.dart';
import 'package:weatherapp/dependencies/send_request.dart';
import 'package:weatherapp/dependencies/json_parser.dart';
import 'package:weatherapp/dependencies/db_handler.dart';

const String CITY_DATA_ERR = "An error occured while fetching cities.";
const String DATA_ERR_NOT_CONNECTED = "Cannot fetch data: You are not connected to the Internet.";
const String CITY_ADDED = "City successfully added!";

class DropDown extends StatefulWidget {
  @override
  DropDownWidgets createState() => DropDownWidgets();
}

TextStyle SnackbarTextStyle() {
  return TextStyle(color: Colors.white);
}

class DropDownWidgets extends State {
  String? selectedCountry = countryList[0];
  String? selectedState;
  String? selectedCity;
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB();
    (context as Element).reassemble();
  }

  Future<int> addUserCity(
      String? userCity, String? userState, String? userCountry) async {
    Entry cityToAdd = Entry(
        cityName: userCity,
        stateName: userState,
        countryName: userCountry,
        isFavourite: 0);
    List<Entry> entryToAdd = [cityToAdd];
    return await this.handler.insertUserCity(entryToAdd);
  }

  Future getStates() async {
    final jsonMap = await fetchStateData(selectedCountry);
    List<States> temp = (jsonMap['data'] as List).map((state) => States.fromJson(state)).toList();
    for (int i = 0; i < temp.length; i++) {
      if (i == 0) 
      {
        stateList.clear();
      }
      stateList.add(temp[i].state.toString());
    }
    (context as Element).reassemble();
  }

  Future getCities() async {
    final jsonMap = await fetchCityData(selectedState, selectedCountry);
    if (jsonMap.containsValue('fail')) {
      ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(CITY_DATA_ERR));
    } else {
      List<Cities> temp = (jsonMap['data'] as List).map((city) => Cities.fromJson(city)).toList();
      for (int i = 0; i < temp.length; i++) {
        if (i == 0) 
        {
          cityList.clear();
        }
        cityList.add(temp[i].city.toString());
      }
      (context as Element).reassemble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                        value: selectedCountry,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (String? data) 
                        {
                          setState(() async 
                          {
                            stateList[0] = 'null';
                            (context as Element).reassemble();
                            selectedCountry = data;
                            try 
                            {
                              final isConnected =
                                  await InternetAddress.lookup('google.com');
                              if (isConnected.isNotEmpty &&
                                  isConnected[0].rawAddress.isNotEmpty) {
                                getStates();
                                selectedState = null;
                                selectedCity = null;
                                cityList[0] = 'null';
                              }
                            } 
                            on SocketException catch (_) 
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  AppTheme.defaultSnackBar(
                                      DATA_ERR_NOT_CONNECTED));
                            }
                          });
                        },
                        items: countryList.map<DropdownMenuItem<String>>((String value) 
                        {
                          return DropdownMenuItem<String>(value: value,child: Text(value));
                        }).toList(),
                        decoration: InputDecoration(labelText: "Select a country...")),
                    if (stateList[0] == 'null') ... //If the first element in stateList says 'null'...
                    [
                      DropdownButtonFormField(items: [], onChanged: null) //Create a dropdown list that has no items. This will disable the dropdown button.
                    ] 
                    else ...
                    [
                      DropdownButtonFormField<String>(
                          value: selectedState,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (String? data) {
                            setState(() async {
                              cityList[0] = 'null';
                              (context as Element).reassemble();
                              selectedState = data;
                              try 
                              {
                                final isConnected =
                                    await InternetAddress.lookup('google.com');
                                if (isConnected.isNotEmpty && isConnected[0].rawAddress.isNotEmpty) 
                                {
                                  getCities();
                                  selectedCity = null;
                                }
                              } 
                              on SocketException catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(DATA_ERR_NOT_CONNECTED));
                              }
                            });
                          },
                          items: stateList.map<DropdownMenuItem<String>>((String value) 
                          {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(labelText: "Select a state...")),
                      if (cityList[0] == 'null') ... //If the first element in cityList is 'null'...
                      [
                        DropdownButtonFormField(items: [], onChanged: null) //Create a dropdown list that has no items. This will disable the dropdown button.
                      ] else ...[
                        DropdownButtonFormField<String>(
                            value: selectedCity,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            onChanged: (String? data) //When the user has selected an item...
                            {
                              setState(() {

                                selectedCity = data;
                              });
                            },
                            items: cityList.map<DropdownMenuItem<String>>((String value) 
                            { 
                              return DropdownMenuItem<String>(value: value, child: Text(value),);
                            }).toList(),
                            decoration: InputDecoration(labelText: "Select a city...")),
                            //The hint text on the drop down will inform the user that they need to select a city.
                        if (selectedCity != null) ... //Only if the user has selected a city...
                        [
                          ElevatedButton( //Create a button that says 'Add City' that will do the following when pressed...
                              onPressed: (() async 
                              {
                                addUserCity(selectedCity, selectedState,selectedCountry); //Call the addUserCity function with the parameters supplied.
                                //This will add the user's selection to the database.
                                ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(CITY_ADDED));
                                //Show a snackbar indicating the city has been added.
                                Navigator.pop(context); //Go back to the main screen.
                              }),
                              child: const Text("Add City"))
                        ]
                      ]
                    ]
                  ],
                ))));
  }
}
