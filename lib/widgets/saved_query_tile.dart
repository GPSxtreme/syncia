import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/saved_collection_controller.dart';
import 'package:syncia/controllers/theme_controller.dart';
import 'package:syncia/models/chat_message.dart';
import 'package:syncia/styles/size_config.dart';
import 'package:syncia/widgets/markdown_response_tile.dart';

class SavedQueryTile extends StatelessWidget {
  const SavedQueryTile({Key? key, required this.chatMessage}) : super(key: key);
  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.grey.withOpacity(0.15),
          child: Container(
            decoration: const BoxDecoration(
                border:
                    Border(left: BorderSide(color: Colors.blue, width: 3.0))),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SelectableText(
                        chatMessage.query,
                        style: const TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.normal),
                      ),
                    )),
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      onSelected: (String result) async {
                        if (result == 'copy') {
                          Clipboard.setData(
                              ClipboardData(text: chatMessage.response));
                          Get.snackbar('Added to clipboard', 'Response copied',
                              icon: const Icon(Icons.check),
                              duration: const Duration(seconds: 2),
                              snackPosition: SnackPosition.BOTTOM);
                        } else if (result == 'delete') {
                          await SavedCollectionController.to
                              .deleteMessage(chatMessage.id);
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'copy',
                          child: ListTile(
                            leading: Obx(() => Icon(
                                  Icons.copy,
                                  color: ThemeController.to.isDarkTheme.value
                                      ? Colors.white
                                      : Colors.black,
                                )),
                            title: const Text('Copy Response'),
                          ),
                        ),
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
                )
              ],
            ),
          ),
        ),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          title: MarkdownResponseTile(response: chatMessage.response),
        ),
      ],
    );
  }
}
