import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncia/styles/app_styles.dart';
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
    // redirect to home page
    Future.delayed(const Duration(seconds: 2), () async {
      Get.put(SettingsController(), permanent: true);
      if (SettingsController.to.apiKeyController.text.isNotEmpty) {
        Get.offAndToNamed(Routes.textChatsPage);
      }
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
              child: Center(child: kDevLogo),
            )
          ],
        ));
  }
}
