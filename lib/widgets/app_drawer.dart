import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/theme_controller.dart';
import 'package:syncia/route.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text(
              'Syncia',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Text chats'),
            onTap: () {
              Get.currentRoute != Routes.textChatsPage
                  ? Get.offAndToNamed(Routes.textChatsPage)
                  : Get.back();
            },
          ),
          Obx(() => ListTile(
                leading: ThemeController.to.isDarkTheme.value
                    ? Icon(Icons.nightlight)
                    : Icon(Icons.sunny),
                title: Text(ThemeController.to.isDarkTheme.value
                    ? 'Dark mode'
                    : 'Light mode'),
                trailing: Obx(() => Switch(
                      value: Get.find<ThemeController>().isDarkTheme.value,
                      onChanged: (value) =>
                          Get.find<ThemeController>().toggleTheme(),
                    )),
              )),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Get.currentRoute != Routes.settingsPage
                  ? Get.offAndToNamed(Routes.settingsPage)
                  : Get.back();
            },
          ),
        ],
      ),
    );
  }
}
