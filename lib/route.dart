import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:syncia/pages/settings.dart';
import 'package:syncia/pages/splash.dart';
import 'package:syncia/pages/text_chat.dart';
import 'package:syncia/pages/text_chats.dart';
import 'package:syncia/pages/saved_collections.dart';

import 'pages/saved_collection.dart';

class Routes {
  static String splashPage = '/splash';
  static String textChatsPage = '/text_chats';
  static String textChatPage = '/text_chat';
  static String settingsPage = '/settings';
  static String savedCollectionsPage = '/saved_collections';
  static String savedCollectionPage = '/saved_collection';
}

final getPages = [
  GetPage(
    name: Routes.splashPage,
    page: () => const SplashPage(),
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
  )
];
