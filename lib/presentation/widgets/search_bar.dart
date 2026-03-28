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
            hintText: "Search destination...",
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: controller.search,
        ),

        Obx(() {
          if (controller.isSearching.value) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (controller.places.isEmpty) {
            return SizedBox();
          }

          return Container(
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.places.length,
              itemBuilder: (context, index) {
                final place = controller.places[index];

                return ListTile(
                  title: Text(place['display_name']),
                  onTap: () => controller.selectPlace(index),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}