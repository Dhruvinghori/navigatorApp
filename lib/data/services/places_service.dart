import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:navigation_app/app/constants/api_constants.dart';

class PlacesService {
  Future<List<dynamic>> searchPlaces(String query) async {
    final url =
        "${ApiConstants.search}?q=$query&format=json";

    final response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }
}