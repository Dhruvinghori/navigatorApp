import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart' hide MapController;
import '../controllers/map_controller.dart';
import '../widgets/search_bar.dart';

class MapPage extends StatelessWidget {
  final controller = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {

        if (controller.current.value.latitude == 0) {
          return Center(child: CircularProgressIndicator());
        }

        return Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: controller.current.value,
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate:
                "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                subdomains: ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.navigation_app',
              ),

              Obx(() => controller.routePoints.isEmpty
                  ? SizedBox()
                  : PolylineLayer(
                polylines: [
                  Polyline(
                    points: controller.routePoints,
                    strokeWidth: 5,
                  )
                ],
              )),

              Obx(() => MarkerLayer(
                markers: [
                  Marker(
                    point: controller.current.value,
                    width: 40,
                    height: 40,
                    child: Icon(Icons.location_pin,
                        color: Colors.blue, size: 40),
                  ),
                  if (controller.destination.value != null)
                    Marker(
                      point: controller.destination.value!,
                      width: 40,
                      height: 40,
                      child: Icon(Icons.location_pin,
                          color: Colors.red, size: 40),
                    ),
                ],
              )),
            ],
          ),

          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: SearchBarWidget(),
          ),

          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Obx(() => Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text("Distance: ${controller.distance.value}"),
                    Text("ETA: ${controller.duration.value}"),
                  ],
                ),
              ),
            )),
          ),
        ],
      );
      }),
    );
  }
}