import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/chats_controller.dart';
import 'package:syncia/controllers/settings_controller.dart';
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
        title: Text(
          'All chats',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        elevation: 0.5,
      ),
      floatingActionButton: SettingsController.to.models.isNotEmpty
          ? FloatingActionButton(
              child: const Icon(
                Icons.add,
                size: 40,
              ),
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Material(
                    shape: const CircleBorder(),
                    color: Theme.of(context).colorScheme.secondary,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Icon(
                        SettingsController.to.models.isEmpty
                            ? Icons.error
                            : Icons.chat,
                        color: Theme.of(context).colorScheme.surfaceDim,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    SettingsController.to.models.isEmpty
                        ? "Error loading models. Please check your api key/internet and try again."
                        : 'No chats available. Create new chat by pressing add icon below',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.surfaceDim),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
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
