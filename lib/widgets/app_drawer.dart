import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/theme_controller.dart';
import 'package:syncia/route.dart';
import 'package:flutter_svg/svg.dart';

import '../styles/size_config.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Drawer(
      elevation: 0,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 30, bottom: 0),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SvgPicture.asset(
                      'assets/svgs/app_bar_logo.svg',
                      height: SizeConfig.blockSizeVertical! * 5,
                      width: SizeConfig.blockSizeHorizontal! * 5,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    const Text(
                      'Syncia',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ]),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical! * 2,
                  ),
                  const Divider(
                    thickness: 1,
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Text chats'),
              onTap: () {
                Get.currentRoute != Routes.textChatsPage
                    ? Get.offAllNamed(Routes.textChatsPage)
                    : Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Image chats'),
              onTap: () {
                Get.currentRoute != Routes.imageChatsPage
                    ? Get.offAllNamed(Routes.imageChatsPage)
                    : Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Saved'),
              onTap: () {
                Get.currentRoute != Routes.savedCollectionsPage
                    ? Get.offAllNamed(Routes.savedCollectionsPage)
                    : Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Get.currentRoute != Routes.settingsPage
                    ? Get.offAllNamed(Routes.settingsPage)
                    : Get.back();
              },
            ),
            Obx(() => SwitchListTile(
                  secondary: ThemeController.to.isDarkTheme.value
                      ? const Icon(Icons.nightlight)
                      : const Icon(Icons.sunny),
                  title: Text(ThemeController.to.isDarkTheme.value
                      ? 'Dark mode'
                      : 'Light mode'),
                  value: Get.find<ThemeController>().isDarkTheme.value,
                  onChanged: (value) =>
                      Get.find<ThemeController>().toggleTheme(),
                )),
          ],
        ),
      ),
    );
  }
}
