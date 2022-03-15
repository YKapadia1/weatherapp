import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'JSONList.dart';
import 'drop_down_country.dart';

var test2;

List<String> listTest = [];

class AddCityRoute extends StatelessWidget {
  const AddCityRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a city...'),
      ),
      body: DropDown(),
    );
  }
}
