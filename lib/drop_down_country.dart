import 'package:flutter/material.dart';
import 'add_city.dart';

class DropDown extends StatefulWidget {
  @override
  DropDownWidget createState() => DropDownWidget();
}

class DropDownWidget extends State {
  String? SelectedDropDownItem = 'Afghanistan';
  List<String> spinnerItems = listTest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: Column(
      children: <Widget>[
        DropdownButtonFormField<String>(
            value: SelectedDropDownItem,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
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
            decoration: InputDecoration(labelText: "Select a country...")),
      ],
    ))));
  }
}
