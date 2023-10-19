import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:syncia/services/local_database_service.dart';
import '../styles/themes.dart';

Brightness brightness =
    SchedulerBinding.instance.platformDispatcher.platformBrightness;

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();
  RxBool isDarkTheme = false.obs;
  Rx<ThemeSetting> themeSetting = ThemeSetting.systemDefault.obs;
  final DatabaseService db = DatabaseService();
  @override
  void onInit() async {
    super.onInit();
    themeSetting.value = await DatabaseService().getThemeSetting();
    isDarkTheme.value = themeSetting.value == ThemeSetting.dark ||
        themeSetting.value == ThemeSetting.systemDefault &&
            brightness == Brightness.dark;
  }

  ThemeData get theme => isDarkTheme.value ? darkTheme : lightTheme;

  Future<void> toggleTheme({ThemeSetting? preset}) async {
    isDarkTheme.value =
        preset != null ? preset == ThemeSetting.dark : !isDarkTheme.value;
    themeSetting.value =
        preset ?? (isDarkTheme.value ? ThemeSetting.dark : ThemeSetting.light);
    await db.setThemeSetting(themeSetting.value);
  }

  Future<void> setToSystemDefault() async {
    isDarkTheme.value = brightness == Brightness.dark;
    themeSetting.value = ThemeSetting.systemDefault;
    await db.setThemeSetting(themeSetting.value);
  }
}
