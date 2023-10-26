import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../route.dart';
import '../styles/size_config.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Get.offAndToNamed(Routes.settingsPage);
  }

  Widget _buildImage(String assetName, {double? width, double? height}) {
    return Image.asset(
      'assets/introduction/$assetName',
      width: width ?? SizeConfig.screenWidth! * 0.6,
      height: height ?? SizeConfig.screenHeight! * 0.7,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    const bodyStyle = TextStyle(fontSize: 18.0);

    const pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
        bodyTextStyle: bodyStyle,
        bodyPadding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
        bodyAlignment: Alignment.center,
        imageAlignment: Alignment.center,
        imageFlex: 2,
        pageMargin: EdgeInsets.only(top: 70, bottom: 60));

    return IntroductionScreen(
      key: introKey,
      allowImplicitScrolling: true,
      // autoScrollDuration: 5000,
      // infiniteAutoScroll: true,
      globalHeader: const Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 16, right: 16),
          ),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Welcome to syncia!",
          body: "The power of ai in your hands",
          image: SvgPicture.asset(
            'assets/svgs/app_bar_logo.svg',
            height: SizeConfig.blockSizeVertical! * 25,
            width: SizeConfig.blockSizeHorizontal! * 25,
            fit: BoxFit.contain,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Almost there..",
          bodyWidget: Column(
            children: [
              const Text(
                "Syncia requires an OPEN AI api key to function.If you are familiar with getting one from this link",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Tooltip(
                message: 'Click here to get api key',
                child: GestureDetector(
                  onLongPress: () {
                    // copy link to clipboard
                    Clipboard.setData(const ClipboardData(
                        text: 'https://platform.openai.com/account/api-keys'));
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
                  child: const Text(
                    'https://platform.openai.com/account/api-keys',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "You can skip this introduction, or else please follow the instructions to get one.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Login",
          image: _buildImage('login-openai.png'),
          bodyWidget: Column(
            children: [
              const Text(
                "Login to your open ai account\nIf your don't have an account you can sign up.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Tooltip(
                message: 'Click here to redirect',
                child: GestureDetector(
                  onLongPress: () {
                    // copy link to clipboard
                    Clipboard.setData(const ClipboardData(
                        text: 'https://platform.openai.com/login'));
                  },
                  onTap: () async {
                    final url = Uri.parse('https://platform.openai.com/login');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: const Text(
                    'https://platform.openai.com/login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          decoration: pageDecoration
            ..copyWith(
              bodyAlignment: Alignment.bottomCenter,
              imageAlignment: Alignment.topCenter,
            ),
        ),
        PageViewModel(
          title: "Menu",
          image: _buildImage('dashboard-openai.png'),
          bodyWidget: const Column(
            children: [
              Text(
                "Press on the menu icon to view all options.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          decoration: pageDecoration
            ..copyWith(
              bodyAlignment: Alignment.bottomCenter,
              imageAlignment: Alignment.topCenter,
            ),
        ),
        PageViewModel(
          title: "Access api keys",
          image: _buildImage('menu-openai.png'),
          bodyWidget: const Column(
            children: [
              Text(
                "From the menu scroll down until you see your account name and click on it. From the menu popped up, press on view API keys",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          decoration: pageDecoration
            ..copyWith(
              bodyAlignment: Alignment.bottomCenter,
              imageAlignment: Alignment.topCenter,
            ),
        ),
        PageViewModel(
          title: "Get api key",
          image: _buildImage('api-page-openai.png'),
          bodyWidget: const Column(
            children: [
              Text(
                "From here you can create a new api key and store it securely. This key will be asked to be inputted in the app.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          decoration: pageDecoration
            ..copyWith(
              bodyAlignment: Alignment.bottomCenter,
              imageAlignment: Alignment.topCenter,
            ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
