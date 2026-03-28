import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapController extends GetxController {
  Rx<LatLng> current = LatLng(0, 0).obs;
  Rx<LatLng?> destination = Rx<LatLng?>(null);
  RxList<LatLng> routePoints = <LatLng>[].obs;
  RxList places = [].obs;
  RxString distance = "".obs;
  RxString duration = "".obs;

  StreamSubscription<Position>? positionStream;
  LatLng? previousPosition;
  RxBool isLoading = true.obs;
  RxBool isSearching = false.obs;
  RxString errorMessage = "".obs;
  Timer? debounce;

  @override
  void onInit() {
    super.onInit();
    initLocation();
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.first == ConnectivityResult.none) {
      errorMessage.value = "No Internet Connection";
      isLoading.value = false;
      return false;
    }

    return true;
  }

  void initLocation() async {
    isLoading.value = true;
    errorMessage.value = "";

    bool hasInternet = await checkInternet();
    if (!hasInternet) return;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      errorMessage.value = "Location (GPS) is OFF. Please enable it.";
      isLoading.value = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      errorMessage.value = "Location permission denied";
      isLoading.value = false;
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      errorMessage.value =
      "Permission permanently denied. Enable from settings.";
      isLoading.value = false;
      return;
    }

    try {
      Position pos = await Geolocator.getCurrentPosition();

      current.value = LatLng(pos.latitude, pos.longitude);

      positionStream =
          Geolocator.getPositionStream().listen((pos) {
            LatLng newPos = LatLng(pos.latitude, pos.longitude);
            animateMarker(newPos);

            if (destination.value != null) {
              drawRoute();
            }
          });

      isLoading.value = false;
    } catch (e) {
      errorMessage.value = "Failed to get location";
      isLoading.value = false;
    }
  }

  void animateMarker(LatLng newPosition) async {
    final old = previousPosition ?? newPosition;

    for (double t = 0; t <= 1; t += 0.1) {
      final lat = old.latitude + (newPosition.latitude - old.latitude) * t;
      final lng = old.longitude + (newPosition.longitude - old.longitude) * t;

      current.value = LatLng(lat, lng);
      await Future.delayed(const Duration(milliseconds: 50));
    }

    previousPosition = newPosition;
  }

  void search(String query) {
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(Duration(milliseconds: 800), () async {
      if (query.isEmpty) return;

       isSearching.value = true;

      final url =
          "https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'navigation_app (your@email.com)',
        },
      );

      if (response.statusCode == 200) {
        places.value = json.decode(response.body);
      } else {
        print("Search error");
      }

      isSearching.value = false;

    });
  }

  void selectPlace(int index) {
    final place = places[index];

    double lat = double.parse(place['lat']);
    double lng = double.parse(place['lon']);

    destination.value = LatLng(lat, lng);

    places.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    drawRoute();
  }

  void drawRoute() async {
    if (destination.value == null) return;

    final url =
        "https://router.project-osrm.org/route/v1/driving/"
        "${current.value.longitude},${current.value.latitude};"
        "${destination.value!.longitude},${destination.value!.latitude}"
        "?overview=full&geometries=polyline";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent': 'navigation_app',
      },
    );

    final data = json.decode(response.body);

    if (data['routes'] == null || data['routes'].isEmpty) return;

    final route = data['routes'][0];

    String geometry = route['geometry'];
    var distanceMeters = route['distance'];
    var durationSeconds = route['duration'];

    List<PointLatLng> points =
    PolylinePoints.decodePolyline(geometry);

    if (points.isEmpty) return;

    routePoints.value =
        points.map((p) => LatLng(p.latitude, p.longitude)).toList();

    distance.value =
        (distanceMeters / 1000).toStringAsFixed(2) + " km";

    duration.value =
        (durationSeconds / 60).toStringAsFixed(0) + " mins";
  }

  void checkRouteDeviation() {
    if (routePoints.isEmpty) return;

    final Distance distanceCalc = Distance();

    double minDistance = double.infinity;

    for (var point in routePoints) {
      double d = distanceCalc.as(
          LengthUnit.Meter, current.value, point);

      if (d < minDistance) {
        minDistance = d;
      }
    }

    if (minDistance > 30) {
      drawRoute();
    }
  }

  @override
  void onClose() {
    positionStream?.cancel();
    super.onClose();
  }
}