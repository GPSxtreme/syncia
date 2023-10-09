import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:syncia/pages/home.dart';
import 'package:syncia/pages/splash.dart';
import 'package:syncia/pages/text_chat.dart';

class Routes {
  static String splashPage = '/splash';
  static String homePage = '/home';
  static String textChatPage = '/text_chat';
}
final getPages = [
  GetPage(
    name: Routes.splashPage,
    page: () => const SplashPage(),
  ),
  GetPage(
    name: Routes.homePage,
    page: () => const HomePage(),
  ),
  GetPage(
    name: Routes.textChatPage,
    page: () => const TextChatPage(),
  )
];