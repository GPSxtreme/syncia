import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'controllers/theme_controller.dart';
import 'route.dart';

class MyApp extends StatelessWidget {
  final ThemeController _themeController = Get.put(ThemeController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      theme: _themeController.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashPage,
      getPages: getPages,
    ));
  }
}

