import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weatherapp/screens/drop_down.dart';
import 'package:weatherapp/dependencies/send_request.dart';

import '../dependencies/my_theme.dart';

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
        appBar: AppBar(title: const Text('Add a city...'), actions: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: GestureDetector(
                            onTap: () async 
                            {
                              BuildContext dialogContext = context;
                              try
                              {
                                final isConnected = await InternetAddress.lookup('google.com');
                                if (isConnected.isNotEmpty && isConnected[0].rawAddress.isNotEmpty)
                                {
                                  showDialog(
                                    context: context, 
                                    barrierDismissible: false,
                                    builder: (BuildContext context)
                                    {
                                      dialogContext = context;
                                      return Dialog(
                                        child:  Row(mainAxisSize: MainAxisSize.max,
                                        children: const [Padding(padding: EdgeInsets.all(15.0), child: CircularProgressIndicator(),), Text("Getting nearest city to you...")],)
                                      );
                                    },);

                                  final jsonMap = await fetchNearestCity();
                                  String nearestCityName = jsonMap['city'];
                                  String nearestStateName = jsonMap['state'];
                                  String nearestCountryName = jsonMap['country'];
                                  Navigator.pop(dialogContext);
                                  showDialog(
                                    context: context, 
                                  barrierDismissible: false,
                                  builder: (BuildContext context)
                                  {
                                    dialogContext = context;
                                    return AlertDialog(
                                      title: Text("Add City?"),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            const Text("The nearest city to you is:"),
                                            Text(nearestCityName),
                                            Text(nearestStateName + ", " + nearestCountryName),
                                            const Text("Would you like to add this city?")
                                          ],
                                        )
                                      ),
                                      actions: <Widget>[
                                        TextButton(child: const Text("Yes"), onPressed: ()
                                        {
                                          //call code here to add city to db
                                          Navigator.of(dialogContext).pop();
                                        },), TextButton(child: const Text("No"), onPressed: ()
                                        {
                                          Navigator.of(dialogContext).pop();
                                        },)
                                      ]
                                    );
                                  });
                                }
                              }
                              on SocketException catch (_)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(dataErrNotConnected));
                              //Display a snackbar to the user telling them they are not connected to the internet.
                              }
                              
                            },
                            child: const Icon(Icons.gps_fixed,size: 26.0,),
                          )),
                    ],),
        body: const Center(child: DropDown()));
        //The body of the stateless widget will be a stateful widget in the center of the screen.
  }
}
