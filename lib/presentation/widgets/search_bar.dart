import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/map_controller.dart';

class SearchBarWidget extends StatelessWidget {
  final controller = Get.find<MapController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: "Search location",
            fillColor: Colors.white,
            filled: true,
          ),
          onChanged: controller.search,
        ),
        Obx(() => ListView.builder(
          shrinkWrap: true,
          itemCount: controller.places.length,
          itemBuilder: (_, i) {
            final place = controller.places[i];
            return ListTile(
              title: Text(place['display_name']),
              onTap: () =>
                  controller.selectPlace(i),
            );
          },
        ))
      ],
    );
  }
}