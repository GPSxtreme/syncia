import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:syncia/route.dart';
import 'package:syncia/services/open_ai_service.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> loadOpenAiModels() async {
    try {
      await OpenAiService.init();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load models.\nClick to retry.',
          icon: const Icon(Icons.error), onTap: (_) {
        loadOpenAiModels();
      });
    }
    return Future.value();
  }

  Future<void> loadApiKey() async {
    String? apiKey = await _storage.read(key: 'OPEN_AI_API_KEY');
    if (apiKey != null) {
      try {
        OpenAI.apiKey = apiKey;
        apiKeyController.text = apiKey;
      } catch (e) {
        Get.snackbar(
            'Error', 'Failed to load api key.\nClick here to view full log',
            icon: const Icon(Icons.error), onTap: (_) {
          Get.toNamed(Routes.viewErrorPage, arguments: {'log': e.toString()});
        });
      } finally {
        loadOpenAiModels();
      }
    }
  }

  Future<void> saveApiKey() async {
    try {
      if (apiKeyController.text.isNotEmpty ||
          apiKeyController.text.length > 10) {
        String apiKey = apiKeyController.text;
        await _storage.write(key: 'OPEN_AI_API_KEY', value: apiKey);
        OpenAI.apiKey = apiKey;
        Get.snackbar('Success', 'Api key updated successfully!',
            icon: const Icon(Icons.check));
        await loadOpenAiModels();
      } else {
        Get.snackbar("Error", "Api key not valid",
            icon: const Icon(Icons.error));
        String? apiKey = await _storage.read(key: 'OPEN_AI_API_KEY');
        if (apiKey != null) {
          apiKeyController.text = apiKey;
          update();
        }
      }
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

  static Future<void> inAppUpdate({bool showElse = false}) async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.completeFlexibleUpdate();
      } else if (showElse) {
        Get.snackbar("App on latest version!", "No updates available");
      }
    } catch (e) {
      Get.snackbar(
          'Error', 'Error checking for update \nClick here to view full log',
          icon: const Icon(Icons.error), onTap: (_) {
        Get.toNamed(Routes.viewErrorPage, arguments: {'log': e.toString()});
      });
    }
  }
}
