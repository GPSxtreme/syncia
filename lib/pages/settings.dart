import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:syncia/controllers/settings_controller.dart';
import 'package:syncia/controllers/theme_controller.dart';
import 'package:syncia/services/local_database_service.dart';
import 'package:syncia/widgets/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../styles/size_config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(centerTitle: true, title: const Text('Settings')),
        body: GetBuilder<SettingsController>(
          builder: (controller) {
            return Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Open AI",
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'You can get the api key from this link',
                              style: TextStyle(fontSize: 16),
                            ),
                            Tooltip(
                              message: 'Click here to get api key',
                              child: GestureDetector(
                                onLongPress: () {
                                  // copy link to clipboard
                                  Clipboard.setData(const ClipboardData(
                                      text:
                                          'https://platform.openai.com/account/api-keys'));
                                },
                                onTap: () async {
                                  final url = Uri.parse(
                                      'https://platform.openai.com/account/api-keys');
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    'https://platform.openai.com/account/api-keys',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.blue),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: TextField(
                                  controller: controller.apiKeyController,
                                  onSubmitted: (_) async {
                                    await controller.saveApiKey();
                                  },
                                  decoration: const InputDecoration(
                                    filled: true,
                                    hintText: "Please input api key",
                                  )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: const Text(
                          "Theme",
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('pick your desired theme setting'),
                              Obx(() => DropdownButton(
                                    isExpanded: true,
                                    value:
                                        ThemeController.to.themeSetting.value,
                                    items: const [
                                      DropdownMenuItem(
                                        value: ThemeSetting.light,
                                        child: Text('Light theme'),
                                      ),
                                      DropdownMenuItem(
                                        value: ThemeSetting.dark,
                                        child: Text('Dark theme'),
                                      ),
                                      DropdownMenuItem(
                                        value: ThemeSetting.systemDefault,
                                        child: Text('System default'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value == ThemeSetting.systemDefault) {
                                        ThemeController.to.setToSystemDefault();
                                      } else {
                                        ThemeController.to
                                            .toggleTheme(preset: value);
                                      }
                                    },
                                  ))
                            ]),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Text(
                          'About App',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'Checkout developer',
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: const Text('Made with ❤️ by prudhvi suraaj'),
                        leading: const Icon(Icons.logo_dev_rounded),
                        onTap: () {
                          controller.launchLink("https://gpsxtre.me/");
                        },
                      ),
                      ListTile(
                        title: const Text(
                          'Chrome extension',
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: const Text('Checkout our chrome extension'),
                        leading: const Icon(Ionicons.logo_chrome),
                        onTap: () {
                          controller.launchLink(
                              "https://chrome.google.com/webstore/detail/syncia-power-of-chatgpt-o/bhdfllifdfodbkihgmahlfmddlmfdjak?hl=en");
                        },
                      ),
                      ListTile(
                        title: const Text(
                          'Open source',
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle:
                            const Text('Check out code & make contributions'),
                        leading: const Icon(Ionicons.logo_github),
                        onTap: () {
                          controller.launchLink(
                              "https://github.com/GPSxtreme/syncia/");
                        },
                      ),
                      ListTile(
                        title: const Text(
                          'Report a bug',
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: const Text(
                            'Help us fix issues by reporting in app bugs'),
                        leading: const Icon(Icons.bug_report),
                        onTap: () {
                          controller.launchLink(
                              "https://github.com/GPSxtreme/syncia/issues/new/choose");
                        },
                      ),
                      ListTile(
                        title: const Text(
                          'Request feature',
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle:
                            const Text('Request a desired feature on github'),
                        leading: const Icon(Icons.device_hub_outlined),
                        onTap: () {
                          controller.launchLink(
                              "https://github.com/GPSxtreme/syncia/issues/new/choose");
                        },
                      ),
                      ListTile(
                        title: const Text(
                          'Check for update',
                          style: TextStyle(fontSize: 18),
                        ),
                        leading: const Icon(Icons.update),
                        onTap: () async {
                          await SettingsController.inAppUpdate(showElse: true);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }
}
