import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/image_chats_controller.dart';
import '../styles/size_config.dart';

class CreateImageChatRoomDialogBox extends StatelessWidget {
  const CreateImageChatRoomDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final nameController = TextEditingController();
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      actionsAlignment: MainAxisAlignment.start,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      title: Container(
        width: SizeConfig.screenWidth! * 0.85,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                splashRadius: 15,
                icon: const Icon(
                  Icons.close,
                  size: 20,
                ),
                onPressed: () {
                  Get.back(); // Close the dialog
                },
              ),
            ),
            const Center(
              child: Text(
                'New chat',
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                splashRadius: 15,
                icon: const Icon(
                  Icons.check,
                  size: 20,
                ),
                onPressed: () async {
                  if (nameController.text.isNotEmpty) {
                    await ImageChatsController.to
                        .createImageChatRoom(nameController.text)
                        .onError((error, stackTrace) {
                      Get.snackbar("Error", "Failed to create chat room");
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Room name',
                  )),
            ]),
      ),
    );
  }
}
