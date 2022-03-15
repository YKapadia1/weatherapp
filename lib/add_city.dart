import 'package:flutter/material.dart';
import 'drop_down.dart';

List<String> countryList = [];
List<String> stateList = ['null'];
List<String> cityList = ['null'];
var tempCountryMap;

var tempStateMap;

class AddCityRoute extends StatelessWidget {
  const AddCityRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a city...'),
        ),
        body: Center(child: DropDown()));
  }
}
