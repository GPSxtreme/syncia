import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:syncia/services/open_ai_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../route.dart';

class SettingsController extends GetxController {
  static SettingsController get to => Get.find();
  final _storage = const FlutterSecureStorage();
  final apiKeyController = TextEditingController();
  final RxString version = RxString('');
  final RxString buildVersion = RxString('');

  @override
  void onInit() async {
    super.onInit();
    await loadApiKey();
    await _getAppVersionData();
  }

  @override
  void dispose() {
    apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _getAppVersionData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
    buildVersion.value = packageInfo.buildNumber;
  }

  Future<void> loadApiKey() async {
    String? apiKey = await _storage.read(key: 'API_KEY');
    if (apiKey != null) {
      try {
        OpenAI.apiKey = apiKey;
        apiKeyController.text = apiKey;
        await OpenAiService.init();
        update();
      } catch (e) {
        Get.snackbar(
            'Error', 'Failed to load api key.\nClick here to view full log',
            icon: const Icon(Icons.error), onTap: (_) {
          Get.toNamed(Routes.viewErrorPage, arguments: {'log': e.toString()});
        });
        Get.toNamed(Routes.settingsPage);
      }
    } else {
      // redirect user to settings page
      Get.snackbar("Alert!", "Please input api key to continue.");
      Get.toNamed(Routes.settingsPage);
    }
  }

  Future<void> saveApiKey() async {
    try {
      String apiKey = apiKeyController.text;
      await _storage.write(key: 'API_KEY', value: apiKey);
      OpenAI.apiKey = apiKey;
      await OpenAiService.init();
      Get.snackbar('Success', 'Api key updated successfully!',
          icon: const Icon(Icons.check));
    } catch (e) {
      Get.snackbar(
          'Error', 'Failed to set api key.\nClick here to view full log',
          icon: const Icon(Icons.error), onTap: (_) {
        Get.toNamed(Routes.viewErrorPage, arguments: {'log': e.toString()});
      });
    }
  }

  Future<void> launchLink(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar('Error', 'Error launching link\nClick here to view full log',
          icon: const Icon(Icons.error), onTap: (_) {
        Get.toNamed(Routes.viewErrorPage, arguments: {'log': e.toString()});
      });
    }
  }
}
