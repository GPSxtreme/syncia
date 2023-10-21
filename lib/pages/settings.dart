import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/settings_controller.dart';
import 'package:syncia/controllers/theme_controller.dart';
import 'package:syncia/services/local_database_service.dart';
import 'package:syncia/styles/app_styles.dart';
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
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.80,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          title: const Text(
                            "Open AI",
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Obx(
                                () => RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          style: TextStyle(
                                              color: ThemeController
                                                      .to.isDarkTheme.value
                                                  ? Colors.white
                                                  : Colors.black),
                                          text:
                                              'You can get the api key from this link\n'),
                                      TextSpan(
                                          text:
                                              'https://platform.openai.com/account/api-keys',
                                          style: const TextStyle(
                                              color: Colors.blue),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse(
                                                  'https://platform.openai.com/account/api-keys');
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              } else {
                                                throw 'Could not launch $url';
                                              }
                                            }),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Obx(
                                  () => TextField(
                                      controller: controller.apiKeyController,
                                      onSubmitted: (_) async {
                                        await controller.saveApiKey();
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            ThemeController.to.isDarkTheme.value
                                                ? Colors.white24
                                                : Colors.black12,
                                        hintText: "Please input api key",
                                        border: InputBorder.none,
                                      )),
                                ),
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
                                        if (value ==
                                            ThemeSetting.systemDefault) {
                                          ThemeController.to
                                              .setToSystemDefault();
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(
                            'App',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            'Report bug',
                            style: TextStyle(fontSize: 18),
                          ),
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
                          onTap: () {},
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                        child: Column(
                      children: [
                        kDevLogo,
                        Obx(() => Text(
                              controller.version.value,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ThemeController.to.isDarkTheme.value
                                      ? Colors.white12
                                      : Colors.black12),
                            ))
                      ],
                    )))
              ],
            );
          },
        ));
  }
}
