import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../styles/themes.dart';

Brightness brightness =
    SchedulerBinding.instance.platformDispatcher.platformBrightness;

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();
  RxBool isDarkTheme =
      (brightness == Brightness.dark).obs; // by default set to light theme

  ThemeData get theme => isDarkTheme.value ? darkTheme : lightTheme;

  void toggleTheme() {
    isDarkTheme.value = !isDarkTheme.value;
  }
}
