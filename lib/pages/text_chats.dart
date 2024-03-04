import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/chats_controller.dart';
import 'package:syncia/controllers/settings_controller.dart';
import 'package:syncia/controllers/theme_controller.dart';
import 'package:syncia/widgets/app_drawer.dart';
import 'package:syncia/widgets/create_text_chat_room_dialog_box.dart';
import '../widgets/text_chat_room_tile.dart';

class TextChatsPage extends StatefulWidget {
  const TextChatsPage({super.key});

  @override
  State<TextChatsPage> createState() => _TextChatsPageState();
}

class _TextChatsPageState extends State<TextChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('All chats'),
        elevation: 0.5,
      ),
      floatingActionButton: SettingsController.to.models.isNotEmpty
          ? FloatingActionButton(
              child: Obx(() => Icon(
                    Icons.add,
                    color: ThemeController.to.isDarkTheme.value
                        ? Colors.blue
                        : Colors.white,
                    size: 40,
                  )),
              onPressed: () => showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return CreateTextChatRoomDialogBox();
                    },
                  ))
          : null,
      body: GetBuilder<ChatsController>(
        assignId: true,
        autoRemove: false,
        builder: (controller) {
          if (controller.chatRooms.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.chatRooms.length,
              itemBuilder: (context, index) {
                return TextChatRoomTile(
                  chatRoomData: controller.chatRooms[index],
                );
              },
            );
          } else if (controller.chatRooms.isEmpty && controller.initialized) {
            return Center(
              child: Text(
                SettingsController.to.models.isEmpty
                    ? "Error loading models!\nPlease check your api key/internet and try again."
                    : 'No chats available\nCreate new chat by pressing add icon below',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
