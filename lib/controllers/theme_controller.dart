import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../styles/themes.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();
  RxBool isDarkTheme = false.obs; // by default set to light theme

  ThemeData get theme => isDarkTheme.value ? darkTheme : lightTheme;

  void toggleTheme() {
    isDarkTheme.value = !isDarkTheme.value;
  }
}
