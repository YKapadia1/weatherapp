import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '769abfc9-64d7-4050-8cd3-79aecfda4830';

Future<Map> fetchCountryData() async {
  final queryParameters = {'key': '769abfc9-64d7-4050-8cd3-79aecfda4830'};
  final uri = Uri.https('api.airvisual.com', '/v2/countries', queryParameters);
  final response = await http.get(uri);
  final responseJson = jsonDecode(response.body);
  return responseJson;
}

Future<Map> fetchStateData(var selectedCountry) async {
  final queryParameters = {
    'country': selectedCountry,
    'key': '769abfc9-64d7-4050-8cd3-79aecfda4830'
  };
  final uri = Uri.https('api.airvisual.com', '/v2/states', queryParameters);
  final response = await http.get(uri);
  final responseJson = jsonDecode(response.body);
  return responseJson;
}


Future<Map> fetchCityData(var selectedState, var selectedCountry) async {
  final queryParameters = {
    'state' : selectedState,
    'country': selectedCountry,
    'key': '769abfc9-64d7-4050-8cd3-79aecfda4830'
  };
  final uri = Uri.https('api.airvisual.com', '/v2/cities', queryParameters);
  final response = await http.get(uri);
  final responseJson = jsonDecode(response.body);
  return responseJson;
}
