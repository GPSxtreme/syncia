import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/image_chats_controller.dart';
import 'package:syncia/models/image_chat_room_data.dart';

import '../route.dart';

class ImageChatRoomTile extends StatelessWidget {
  const ImageChatRoomTile({super.key, required this.chatRoomData});
  final ImageChatRoomData chatRoomData;
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
      trailing: IconButton(
        onPressed: () async {
          await ImageChatsController.to.deleteChatRoom(chatRoomData.id);
        },
        icon: const Icon(
          Icons.delete,
          size: 30,
        ),
      ),
    );
  }
}
