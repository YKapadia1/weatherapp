import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final DropDownMenu = new Container();

class DropDown extends StatefulWidget {
  @override
  DropDownWidget createState() => DropDownWidget();
}

class DropDownWidget extends State {
  String? SelectedDropDownItem = 'Item One';
  List<String> spinnerItems = [
    'Item One',
    'Item Two',
    'Item Three',
    'Item Four',
    'Item Five'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
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
      ],
    ))));
  }
}
