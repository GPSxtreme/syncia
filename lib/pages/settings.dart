import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/settings_controller.dart';
import 'package:syncia/widgets/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(centerTitle: true, title: const Text('Settings')),
        body: GetBuilder<SettingsController>(
          builder: (controller) {
            return Column(
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
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                                text:
                                    'You can get the api key from this link\n'),
                            TextSpan(
                                text:
                                    'https://platform.openai.com/account/api-keys',
                                style: const TextStyle(color: Colors.blue),
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
                              fillColor: Colors.white24,
                              hintText: "Please input api key",
                              border: InputBorder.none,
                            )),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }
}
