import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/image_chats_controller.dart';
import 'package:syncia/widgets/app_drawer.dart';
import 'package:syncia/widgets/create_image_chat_room_dialog_box.dart';
import 'package:syncia/widgets/image_chat_room_tile.dart';
import '../controllers/theme_controller.dart';

class ImageChatsPage extends StatelessWidget {
  const ImageChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("All chats"),
        elevation: 0.5,
      ),
      drawer: const AppDrawer(),
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
                  return const CreateImageChatRoomDialogBox();
                },
              )),
      body: GetBuilder<ImageChatsController>(
        init: ImageChatsController(),
        builder: (controller) {
          if (controller.chatRooms.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.chatRooms.length,
              itemBuilder: (context, index) {
                return ImageChatRoomTile(
                  chatRoomData: controller.chatRooms[index],
                );
              },
            );
          } else if (controller.chatRooms.isEmpty && controller.initialized) {
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
    );
  }
}
