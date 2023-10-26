import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:syncia/pages/introduction.dart';
import 'errors/view_error.dart';
import 'pages/image_chat.dart';
import 'pages/image_full_screen.dart';
import 'pages/settings.dart';
import 'pages/splash.dart';
import 'pages/text_chat.dart';
import 'pages/text_chats.dart';
import 'pages/saved_collections.dart';
import 'pages/image_chats.dart';
import 'pages/saved_collection.dart';

class Routes {
  static String splashPage = '/splash';
  static String introductionPage = '/introduction';
  static String textChatsPage = '/text_chats';
  static String textChatPage = '/text_chat';
  static String settingsPage = '/settings';
  static String savedCollectionsPage = '/saved_collections';
  static String savedCollectionPage = '/saved_collection';
  static String imageChatsPage = '/image_chats';
  static String imageChatPage = '/image_chat';
  static String imageFullScreenPage = '/image_full_screen';
  static String viewErrorPage = '/view_error';
}

final getPages = [
  GetPage(
    name: Routes.splashPage,
    page: () => const SplashPage(),
  ),
  GetPage(
    name: Routes.introductionPage,
    page: () => const Introduction(),
  ),
  GetPage(
    name: Routes.textChatsPage,
    page: () => const TextChatsPage(),
  ),
  GetPage(
    name: Routes.textChatPage,
    page: () => const TextChatPage(),
  ),
  GetPage(
    name: Routes.settingsPage,
    page: () => const SettingsPage(),
  ),
  GetPage(
    name: Routes.savedCollectionsPage,
    page: () => const SavedCollectionsPage(),
  ),
  GetPage(
    name: Routes.savedCollectionPage,
    page: () => const SavedCollectionPage(),
  ),
  GetPage(
    name: Routes.imageChatsPage,
    page: () => const ImageChatsPage(),
  ),
  GetPage(
    name: Routes.imageChatPage,
    page: () => const ImageChatPage(),
  ),
  GetPage(
    name: Routes.imageFullScreenPage,
    page: () => const ImageFullScreenPage(),
  ),
  GetPage(
    name: Routes.viewErrorPage,
    page: () => const ViewErrorPage(),
  )
];
