import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:syncia/pages/text_chat.dart';
import 'package:flutter/material.dart';
import 'route.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(color: Colors.white),
                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                backgroundColor: Colors.blue,
              )
          ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
        )
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashPage,
      getPages: getPages,
    );
  }
}
