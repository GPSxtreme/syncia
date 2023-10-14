import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/chats_controller.dart';
import 'package:syncia/widgets/app_drawer.dart';
import 'package:syncia/widgets/create_text_chat_room_dialog_box.dart';
import '../controllers/theme_controller.dart';
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
      floatingActionButton: FloatingActionButton(
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
              )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GetBuilder<ChatsController>(
            assignId: true,
            init: ChatsController(),
            autoRemove: false,
            builder: (controller) {
              if (controller.chatRooms.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.chatRooms.length,
                    itemBuilder: (context, index) {
                      return TextChatRoomTile(
                        chatRoomData: controller.chatRooms[index],
                      );
                    },
                  ),
                );
              } else if (controller.chatRooms.isEmpty &&
                  controller.initialized) {
                return const Center(
                  child: Text(
                    'No chats available\nCreate new chat by pressing add icon below',
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
        ],
      ),
    );
  }
}
