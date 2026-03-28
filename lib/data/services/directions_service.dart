import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../../app/constants/api_constants.dart';

class DirectionsService {
  Future<Map<String, dynamic>> getRoute(
      double startLat,
      double startLng,
      double endLat,
      double endLng) async {

    final url =
        "${ApiConstants.drivingAPI}/"
        "$startLng,$startLat;$endLng,$endLat"
        "?overview=full&geometries=polyline&alternatives=true";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    final route = data['routes'][0];

    String geometry = route['geometry'];
    double distanceMeters = route['distance'];
    double durationSeconds = route['duration'];

    List<PointLatLng> polylinePoints =
    PolylinePoints.decodePolyline(geometry);

    return {
      "points": polylinePoints,
      "distance": (distanceMeters / 1000).toStringAsFixed(2) + " km",
      "duration": (durationSeconds / 60).toStringAsFixed(0) + " mins",
    };
  }
}