import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'JSONList.dart';
import 'drop_down.dart';

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
        onPressed: () async {
          Map resp = await fetchData();
          resp.forEach((data, country) {
            print(country);
          });
        },
        child: const Icon(Icons.web),
      ),
    );
  }
}
