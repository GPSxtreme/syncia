import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/theme_controller.dart';
import 'package:syncia/route.dart';
import 'package:flutter_svg/svg.dart';

import '../styles/size_config.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Drawer(
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
                  Divider(
                    thickness: 2,
                    color: Colors.grey[300],
                  )
                ],
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
                      ? const Icon(Icons.nightlight)
                      : const Icon(Icons.sunny),
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
              leading: const Icon(Icons.bookmark),
              title: const Text('Saved'),
              onTap: () {
                Get.currentRoute != Routes.savedCollectionsPage
                    ? Get.offAndToNamed(Routes.savedCollectionsPage)
                    : Get.back();
              },
            ),
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
      ),
    );
  }
}
