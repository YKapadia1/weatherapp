import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '769abfc9-64d7-4050-8cd3-79aecfda4830';

var request = http.MultipartRequest(
    'GET', Uri.parse('http://api.airvisual.com/v2/countries?key=' + apiKey));

void getResponse() async {
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}

Future<Map> fetchData() async {
  final queryParameters = {'key': '769abfc9-64d7-4050-8cd3-79aecfda4830'};
  final uri = Uri.https('api.airvisual.com', '/v2/countries', queryParameters);
  final response = await http.get(uri);
  final responseJson = jsonDecode(response.body);
  return responseJson;
}
