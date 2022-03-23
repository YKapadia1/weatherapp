import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '769abfc9-64d7-4050-8cd3-79aecfda4830';
//The API key that will be used when sending a request. This is unique to my app.

Future<Map> fetchCountryData() async //A function to get all listed countries the API supports.
{
  final queryParameters = {'key': apiKey}; //The parameters to supply when making the request. In this case, the only parameter is the API key.
  final uri = Uri.https('api.airvisual.com', '/v2/countries', queryParameters); //The complete URI.
  final response = await http.get(uri); //Get the response back from the API. Because the response will not be instant, the keyword await is used.
  final responseJson = jsonDecode(response.body); //Decode the JSON that the API returns and store it in a variable.
  return responseJson; //Return the JSON to the caller.
}

Future<Map> fetchStateData(var selectedCountry) async //A function to get all listed states from a specified country.
{
  final queryParameters = {'country': selectedCountry, 'key': apiKey}; //The parameters are the specified country, as well as the API key.
  final uri = Uri.https('api.airvisual.com', '/v2/states', queryParameters);
  final response = await http.get(uri);
  final responseJson = jsonDecode(response.body);
  return responseJson;
}

Future<Map> fetchCityData(var selectedState, var selectedCountry) async //A function to get all listed cities from a specified country and state.
{
  final queryParameters = 
  {
    'state': selectedState,
    'country': selectedCountry,
    'key': apiKey
  }; //The parameters are the specified country, state, as well as the API key.
  final uri = Uri.https('api.airvisual.com', '/v2/cities', queryParameters);
  final response = await http.get(uri);
  final responseJson = jsonDecode(response.body);
  return responseJson;
}

Future<Map> fetchWeatherData(var selectedCity, var selectedState, var selectedCountry) async 
//A function to get the weather of a specified city. The state the city is in as well as the country need to be specified.
{
  final queryParameters = 
  {
    'city': selectedCity,
    'state': selectedState,
    'country': selectedCountry,
    'key': apiKey
  };
  final uri = Uri.https('api.airvisual.com', '/v2/city', queryParameters);
  final response = await http.get(uri);
  final responseJson = jsonDecode(response.body)['data'];
  return responseJson;
}

Future<Map> fetchNearestCity() async
{
  final queryParameters = {'key' : apiKey};
  final uri = Uri.https('api.airvisual.com', '/v2/nearest_city',queryParameters);
  final response = await http.get(uri);
  final responseJson = jsonDecode(response.body)['data'];
  return responseJson;
}
