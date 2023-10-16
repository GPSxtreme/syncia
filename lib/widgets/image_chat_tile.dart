import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:syncia/controllers/image_chat_controller.dart';
import 'package:syncia/models/image_room_message.dart';
import 'package:get/get.dart';

import '../controllers/theme_controller.dart';

class ImageChatTile extends StatelessWidget {
  const ImageChatTile({super.key, required this.message});
  final ImageRoomMessage message;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
            color: Colors.grey.withOpacity(0.15),
            child: Container(
              decoration: const BoxDecoration(
                  border:
                      Border(left: BorderSide(color: Colors.blue, width: 3.0))),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 18),
                    child: SelectableText(
                      message.query,
                      style: const TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.normal),
                    ),
                  )),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    onSelected: (String result) async {
                      if (result == 'delete') {
                        await ImageChatController.to.deleteMessage(message.id);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: ListTile(
                          leading: Obx(() => Icon(
                                Icons.delete_outline,
                                color: ThemeController.to.isDarkTheme.value
                                    ? Colors.white
                                    : Colors.black,
                              )),
                          title: const Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        CachedNetworkImage(
          imageUrl: message.imageLinks.first,
          cacheKey: message.imageLinks.first.split('/').last,
          progressIndicatorBuilder: (context, url, progress) {
            return Center(
                heightFactor: 5,
                child: CircularProgressIndicator(value: progress.progress));
          },
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ],
    );
  }
}
