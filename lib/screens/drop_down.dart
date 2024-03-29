import 'dart:io';
import 'package:flutter/material.dart';
import 'package:weatherapp/dependencies/my_theme.dart';
import '../user_city_table_model.dart';
import 'add_city.dart';
import 'package:weatherapp/dependencies/send_request.dart';
import 'package:weatherapp/dependencies/json_parser.dart';
import 'package:weatherapp/dependencies/db_handler.dart';

const String cityDataErr = "An error occured while fetching cities.";
const String dataErrNotConnected = "Cannot fetch data: You are not connected to the Internet.";
const String cityAdded = "City successfully added!";
//Snackbar messages to display to the user depending on the action.

class DropDown extends StatefulWidget 
{
  const DropDown({Key? key}) : super(key: key);

  @override
  DropDownWidgets createState() => DropDownWidgets();
}


class DropDownWidgets extends State 
{
  String? selectedCountry = countryList[0];
  String? selectedState;
  String? selectedCity;
  late DatabaseHandler handler;
  //Initialise the needed variables for the screen to function.

  @override
  void initState() 
  {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB();
    (context as Element).reassemble();
    //Initialise the state by initialising the database handler and the city database, then refresh the screen.
  }

  Future<int> addUserCity(String? userCity, String? userState, String? userCountry) async 
  //The functions that adds the user's city selection to the database.
  {
    UserCityDetails cityToAdd = UserCityDetails(
        cityName: userCity,
        stateName: userState,
        countryName: userCountry,
        isFavourite: 0);
        //Create a new data model instance with the user's selection.
    List<UserCityDetails> entryToAdd = [cityToAdd]; //Convert into a list of data model instances.
    return await handler.insertUserCity(entryToAdd);
    //Add the user's selection to the database.
  }

  Future getStates() async 
  //The function that gets and parses a country's state list from the API into a drop down list.
  {
    BuildContext dialogContext = context;
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
    },
    //Show a dialog box that cannot be dismissed. Inside the dialog box, place a circular progress indicator.
    //Also, show text that informs the user that that the app is getting the cities...
   );
    final jsonMap = await fetchStateData(selectedCountry); //Call the API to fetch the state list.
    Navigator.pop(dialogContext);
    if (jsonMap.containsValue('fail')) //If the return code was not success...
    {
      ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(cityDataErr)); //Display a snackbar indicating that an error occured.
      //This is needed as the API can return a status code of no supported states found.
    }
    else
    {
      List<States> temp = (jsonMap['data'] as List).map((state) => States.fromJson(state)).toList();
    //Create a list of states by parsing the key value pairs inside of the 'data' part of the JSON return.
    for (int i = 0; i < temp.length; i++) 
    {
      if (i == 0) //If inserting the first state...
      {
        stateList.clear(); //Clear the state list as it might have states already inside of it.
      }
      stateList.add(temp[i].state.toString());
      //Put the state data into a list of states so it is easier to use as the drop down items.
    }
    (context as Element).reassemble();
    } 
  }

  Future getCities() async 
  //The function that gets and parses a state's city list from the API into a drop down list.
  {
    BuildContext dialogContext = context;
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (BuildContext context)
      {
        dialogContext = context;
        return Dialog(
        child:  Row(mainAxisSize: MainAxisSize.max,
        children: const [Padding(padding: EdgeInsets.all(15.0), child: CircularProgressIndicator(),), Text("Getting cities...")],)
        );
      },
    //Show a dialog box that cannot be dismissed. Inside the dialog box, place a circular progress indicator.
    //Also, show text that informs the user that that the app is getting the cities...
    );
    final jsonMap = await fetchCityData(selectedState, selectedCountry); //Get the city list from the API.
    Navigator.pop(dialogContext);
    if (jsonMap.containsValue('fail')) //If the return code was not success...
    {
      ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(cityDataErr)); //Display a snackbar indicating that an error occured.
      //This is needed as the API can return a status code of no supported cities found.
    } 
    else 
    {
      List<Cities> temp = (jsonMap['data'] as List).map((city) => Cities.fromJson(city)).toList();
      for (int i = 0; i < temp.length; i++) 
      {
        if (i == 0) 
        {
          cityList.clear();
        }
        cityList.add(temp[i].city.toString());
        //One by one, add the cities that are returned into a list.
      }
      (context as Element).reassemble(); //Refresh the screen.
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a city...'), //Create an appBar with the title of "Add a city..."
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector( //Inside the app bar is a gesture detector with the icon of adding a location.
              onTap: () async //When the gesture detector is tapped...
              {
                BuildContext dialogContext = context;
                try
                {
                  final isConnected = await InternetAddress.lookup('google.com'); //Check for an internet connection...
                  if (isConnected.isNotEmpty && isConnected[0].rawAddress.isNotEmpty) //If there is an internet connection...
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
                      },
                      //Show a dialog box that cannot be dismissed. Inside the dialog box, place a circular progress indicator.
                      //Also, show text that informs the user that that the app is getting a city closest to them based on their IP address location.
                    );
                      final jsonMap = await fetchNearestCity(); //Call the function to get the nearest city and store the response in a jsonMap.
                      String nearestCityName = jsonMap['city'];
                      String nearestStateName = jsonMap['state'];
                      String nearestCountryName = jsonMap['country'];
                      //Set variables relating to the data inside the jsonMap.
                      Navigator.pop(dialogContext); //Dismiss the dialog box.
                      if (jsonMap.containsValue('fail')) //If the return code was not success...
                      {
                        ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(cityDataErr)); //Display a snackbar indicating that an error occured.
                        //This is needed as the API can return a status code of no supported cities found.
                      } 
                      else
                      {
                        showDialog(
                        context: context, 
                        barrierDismissible: false,
                        builder: (BuildContext context)
                        {
                          dialogContext = context;
                          return AlertDialog(
                            title: const Text("Add City?"),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  const Text("The nearest city to you is:"),
                                  Text(nearestCityName),
                                  Text(nearestStateName + ", " + nearestCountryName),
                                  const Text("Would you like to add this city?")
                                  ]
                                )
                              ),
                              //Show an alert dialog box with the response from the API.
                              //Ask the user if they want to add the city to their list.
                              actions: <Widget>
                              [
                                TextButton(child: const Text("Yes"), onPressed: () //If the user presses the yes button...
                                {
                                  addUserCity(nearestCityName ,nearestStateName, nearestCountryName); //Add the city to their list.
                                  Navigator.of(dialogContext).pop(); //Remove the dialog box.
                                  ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(cityAdded)); //Show a snackbar indicating the city was added.
                                  Navigator.pop(context); //Go back to the main screen.
                                }), 
                                TextButton(child: const Text("No"), onPressed: () //If the user presses the no button...
                                  {Navigator.of(dialogContext).pop();}) //Dismiss the dialog box.
                              ]
                            );
                          });
                      }
                        }
                      }
                      on SocketException catch (_) //If no internet connection was found...
                      {
                        ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(dataErrNotConnected));
                        //Display a snackbar to the user telling them they are not connected to the internet.
                      }
                    },
                    child: const Icon(Icons.gps_fixed,size: 26.0,),
                    )),
                  ],),
        body: Center(
            child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                        value: selectedCountry,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (String? data) //When the user has selected a country...
                        {
                          setState(() async 
                          {
                            stateList[0] = 'null'; //Set the first element of stateList to 'null'. 
                            //This is to prevent the user from selecting a non existent element in the state drop down list and causing an error.
                            (context as Element).reassemble(); //Refresh the screen to ensure the state drop down list remains disabled.
                            selectedCountry = data; //Update the selected value.
                            try //Try to...
                            {
                              final isConnected = await InternetAddress.lookup('google.com'); //Lookup the address of google.com.
                              //This is to ensure the user still has an internet connection.
                              if (isConnected.isNotEmpty && isConnected[0].rawAddress.isNotEmpty) //If there is an internet connection...
                              {
                                getStates(); //Call on the API to get the states.
                                selectedState = null; //Set the value of the selected state to null.
                                selectedCity = null; //Set the value of the selected city to null.
                                cityList[0] = 'null';//Set the first element of cityList to 'null'. 
                                //This is to prevent the user from selecting a non existent element in the city drop down list and causing an error.
                              }
                            } 
                            on SocketException catch (_) //If a SocketException was thrown, indicating the user has no internet connection...
                            {
                              ScaffoldMessenger.of(context).showSnackBar( AppTheme.defaultSnackBar(dataErrNotConnected));
                              //Display a snackbar to the user telling them they are not connected to the internet.
                            }
                          });
                        },
                        items: countryList.map<DropdownMenuItem<String>>((String value) 
                        {return DropdownMenuItem<String>(value: value,child: Text(value));}).toList(),
                        decoration: const InputDecoration(labelText: "Select a country...")),
                    if (stateList[0] != 'null') ... //If the first element in stateList says 'null'...
                    [
                      DropdownButtonFormField<String>(
                          value: selectedState,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (String? data) 
                          {
                            setState(() async 
                            {
                              cityList[0] = 'null';
                              (context as Element).reassemble();
                              selectedState = data;
                              try 
                              {
                                final isConnected = await InternetAddress.lookup('google.com');
                                if (isConnected.isNotEmpty && isConnected[0].rawAddress.isNotEmpty) 
                                {
                                  getCities();
                                  selectedCity = null;
                                }
                              } 
                              on SocketException catch (_) 
                              {
                                ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(dataErrNotConnected));
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
                          decoration: const InputDecoration(labelText: "Select a state...")),
                      if (cityList[0] != 'null') ... //If the first element in cityList is 'null'...
                      [
                        DropdownButtonFormField<String>(
                            value: selectedCity,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            onChanged: (String? data) //When the user has selected an item...
                            {
                              setState(() 
                              {
                                selectedCity = data;
                              });
                            },
                            items: cityList.map<DropdownMenuItem<String>>((String value) 
                            { 
                              return DropdownMenuItem<String>(value: value, child: Text(value),);
                            }).toList(),
                            decoration: const InputDecoration(labelText: "Select a city...")),
                            //The hint text on the drop down will inform the user that they need to select a city.
                        if (selectedCity != null) ... //Only if the user has selected a city...
                        [
                          ElevatedButton( //Create a button that says 'Add City' that will do the following when pressed...
                              onPressed: (() async 
                              {
                                addUserCity(selectedCity, selectedState,selectedCountry); //Call the addUserCity function with the parameters supplied.
                                //This will add the user's selection to the database.
                                ScaffoldMessenger.of(context).showSnackBar(AppTheme.defaultSnackBar(cityAdded));
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
