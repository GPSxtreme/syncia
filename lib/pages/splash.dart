import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/image_chats_controller.dart';
import 'package:syncia/styles/app_styles.dart';
import '../controllers/chats_controller.dart';
import '../controllers/saved_collections_controller.dart';
import '../controllers/settings_controller.dart';
import '../route.dart';
import '../styles/size_config.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _performInitState();
  }

  _performInitState() async {
    Get.put(SettingsController(), permanent: true);
    Get.put(ChatsController(), permanent: true);
    Get.put(ImageChatsController(), permanent: true);
    Get.put(SavedCollectionsController(), permanent: true);
    await SettingsController.inAppUpdate().then((_) {
      Future.delayed(const Duration(seconds: 2), () async {
        if (SettingsController.to.apiKeyController.text.isNotEmpty) {
          Get.offAndToNamed(Routes.textChatsPage);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/svgs/app_bar_logo.svg',
                height: SizeConfig.screenWidth! * 0.5,
                width: SizeConfig.screenWidth! * 0.5,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(child: kDevLogoWithVersion),
            )
          ],
        ));
  }
}
