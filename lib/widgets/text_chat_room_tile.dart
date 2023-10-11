import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncia/controllers/home_controller.dart';
import 'package:syncia/models/chat_room_data.dart';
import 'package:get/get.dart';

import '../route.dart';

class TextChatRoomTile extends StatelessWidget {
  const TextChatRoomTile({super.key, required this.chatRoomData});
  final ChatRoomData chatRoomData;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: AnimatedTextKit(
        isRepeatingAnimation: false,
        totalRepeatCount: 1,
        animatedTexts: [
          TypewriterAnimatedText(
            chatRoomData.name,
            speed: const Duration(milliseconds: 100),
            textStyle: const TextStyle(fontSize: 15),
          )
        ],
      ),
      onTap: () {
        // go to text chat page
        Get.toNamed(Routes.textChatPage, arguments: {
          'roomId': chatRoomData.id,
          'modelId': chatRoomData.modelName,
        });
      },
      subtitle: Text(
        'Created on : ${DateFormat('d MMMM, h:mm a').format(DateTime.parse(chatRoomData.createdOn).toLocal())}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: IconButton(
        onPressed: () async {
          await HomeController.to.deleteChatRoom(chatRoomData.id);
        },
        icon: const Icon(
          Icons.delete,
          size: 30,
        ),
      ),
    );
  }
}
