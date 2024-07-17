import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncia/controllers/theme_controller.dart';
import 'package:syncia/styles/size_config.dart';
import 'route.dart';

class MyApp extends StatelessWidget {
  final ThemeController _themeController =
      Get.put(ThemeController(), permanent: true);
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Obx(() => GetMaterialApp(
          theme: _themeController.theme,
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.splashPage,
          getPages: getPages,
        ));
  }
}
