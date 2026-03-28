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
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => controller.initLocation(),
                  child: Text("Retry"),
                )
              ],
            ),
          );
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

                Obx(() {
                  if (controller.routes.isEmpty) return SizedBox();

                  return PolylineLayer(
                    polylines: List.generate(controller.routes.length, (index) {
                      return Polyline(
                        points: controller.routes[index],
                        strokeWidth: index == controller.selectedRouteIndex.value ? 6 : 4,
                        color: index == controller.selectedRouteIndex.value
                            ? Colors.blue
                            : Colors.grey,
                      );
                    }),
                  );
                }),

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
              top: 50,
              left: 15,
              right: 15,
              child: SearchBarWidget(),
            ),

            Positioned(
              bottom: 20,
              left: 15,
              right: 15,
              child: Obx(() {
                if (controller.distance.value.isEmpty) {
                  return SizedBox();
                }

                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Distance: ${controller.distance.value}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "ETA: ${controller.duration.value}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            Positioned(
              bottom: 120,
              left: 10,
              right: 10,
              child: Obx(() {
                if (controller.routes.length <= 1) return SizedBox();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(controller.routes.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        controller.selectedRouteIndex.value = index;
                        controller.updateSelectedRouteInfo();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.all(8),
                        color: controller.selectedRouteIndex.value == index
                            ? Colors.blue
                            : Colors.grey,
                        child: Text("Route ${index + 1}",
                            style: TextStyle(color: Colors.white)),
                      ),
                    );
                  }),
                );
              }),
            ),

            Positioned(
              top: 120,
              right: 15,
              child: Obx(() {
                if (controller.destination.value == null) {
                  return SizedBox();
                }

                return FloatingActionButton(
                  onPressed: controller.stopNavigation,
                  child: Icon(Icons.stop,size: 30,),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}