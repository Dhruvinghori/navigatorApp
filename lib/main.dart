import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigation_app/presentation/pages/map_page.dart';
import 'presentation/controllers/map_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Map Navigation',
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(MapController());
      }),
      home: MapPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
    );
  }
}