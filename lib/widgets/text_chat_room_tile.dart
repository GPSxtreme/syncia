import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncia/controllers/chats_controller.dart';
import 'package:syncia/models/chat_room_data.dart';
import 'package:get/get.dart';
import '../route.dart';
import 'common_widgets.dart';

class TextChatRoomTile extends StatelessWidget {
  const TextChatRoomTile({super.key, required this.chatRoomData});
  final ChatRoomData chatRoomData;

  _showModalBottomSheet(BuildContext context) => showModalBottomSheet(
      showDragHandle: true,
      context: context,
      backgroundColor: Theme.of(context).colorScheme.secondary,
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
                    await ChatsController.to.deleteChatRoom(chatRoomData.id);
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
          Get.toNamed(Routes.textChatPage, arguments: chatRoomData.toMap());
        },
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            'Created on: ${DateFormat('h:mm a, d MMM yy').format(DateTime.parse(chatRoomData.createdOn).toLocal())}',
            style: const TextStyle(fontSize: 15),
          ),
        ),
        onLongPress: () {
          _showModalBottomSheet(context);
        });
  }
}
