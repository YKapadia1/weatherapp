import 'package:flutter/material.dart';
import 'add_city.dart';
import 'send_request.dart';
import 'json_parser.dart';

class DropDown extends StatefulWidget {
  @override
  DropDownWidgets createState() => DropDownWidgets();
}

class DropDownWidgets extends State with TickerProviderStateMixin {
  String? selectedCountry = countryList[0];
  String? selectedState;
  String? selectedCity;

  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
    (context as Element).reassemble();
  }

  Future getStates() async {
    final jsonMap = await fetchStateData(selectedCountry);
    List<States> temp = (jsonMap['data'] as List)
        .map((state) => States.fromJson(state))
        .toList();
    for (int i = 0; i < temp.length; i++) {
      if (i == 0) {
        stateList.clear();
      }
      stateList.add(temp[i].state.toString());
    }

    (context as Element).reassemble();
  }

  Future getCities() async {
    final jsonMap = await fetchCityData(selectedState, selectedCountry);
    List<Cities> temp =
        (jsonMap['data'] as List).map((city) => Cities.fromJson(city)).toList();
    for (int i = 0; i < temp.length; i++) {
      if (i == 0) {
        cityList.clear();
      }
      cityList.add(temp[i].city.toString());
    }
    (context as Element).reassemble();
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
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        onChanged: (String? data) {
                          setState(() async {
                            stateList[0] = 'null';
                            (context as Element).reassemble();
                            selectedCountry = data;
                            getStates();
                            selectedState = null;
                            selectedCity = null;
                            cityList[0] = 'null';
                          });
                        },
                        items: countryList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration:
                            InputDecoration(labelText: "Select a country...")),
                    if (stateList[0] == 'null') ...[
                      DropdownButtonFormField(items: [], onChanged: null)
                    ] else ...[
                      DropdownButtonFormField<String>(
                          value: selectedState,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          onChanged: (String? data) {
                            setState(() {
                              cityList[0] = 'null';
                              (context as Element).reassemble();
                              selectedState = data;
                              getCities();
                              selectedCity = null;
                              print(cityList);
                            });
                          },
                          items: stateList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration:
                              InputDecoration(labelText: "Select a state...")),
                      if (cityList[0] == 'null') ...[
                        DropdownButtonFormField(items: [], onChanged: null)
                      ] else ...[
                        DropdownButtonFormField<String>(
                            value: selectedCity,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            onChanged: (String? data) {
                              setState(() {
                                selectedCity = data;
                              });
                            },
                            items: cityList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration:
                                InputDecoration(labelText: "Select a city..."))
                      ]
                    ]
                  ],
                ))));
  }
}
