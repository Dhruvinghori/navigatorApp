import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesService {
  Future<List<dynamic>> searchPlaces(String query) async {
    final url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json";

    final response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }
}