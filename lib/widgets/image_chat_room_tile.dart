import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/image_chats_controller.dart';
import 'package:syncia/models/image_chat_room_data.dart';
import 'package:syncia/widgets/common_widgets.dart';

import '../route.dart';

class ImageChatRoomTile extends StatelessWidget {
  const ImageChatRoomTile({super.key, required this.chatRoomData});
  final ImageChatRoomData chatRoomData;

  _showModalBottomSheet(BuildContext context) => showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () async {
                  bool? response = await CommonWidgets.commonAlertDialog(
                      context,
                      title: 'Delete room?',
                      body: 'This action is irreversible',
                      agreeLabel: "Yes",
                      denyLabel: "No");
                  if (response == true) {
                    await ImageChatsController.to
                        .deleteChatRoom(chatRoomData.id);
                  }
                  Get.back();
                },
                leading: const Icon(Icons.delete),
                title: const Text('Delete room'),
              )
            ],
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        chatRoomData.name,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: () {
        // go to text chat page
        Get.toNamed(Routes.imageChatPage, arguments: chatRoomData.toJson());
      },
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          'Created on : ${DateFormat('d MMMM, h:mm a').format(DateTime.parse(chatRoomData.createdOn).toLocal())}',
          style: const TextStyle(fontSize: 15),
        ),
      ),
      onLongPress: () {
        _showModalBottomSheet(context);
      },
    );
  }
}
