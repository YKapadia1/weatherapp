import 'package:flutter/material.dart';
import 'package:weatherapp/screens/drop_down.dart';

List<String> countryList = [];
List<String> stateList = ['null'];
List<String> cityList = ['null'];
//String lists to store the country list, state list and city list returned by the API.
//This will then be used as the lists for each of the drop down's, allowing the user to select an item.



class AddCityRoute extends StatelessWidget 
{
  const AddCityRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
        appBar: AppBar(title: const Text('Add a city...')),
        body: const Center(child: DropDown()));
        //The body of the stateless widget will be a stateful widget in the center of the screen.
  }
}
