import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/chat_controller.dart';
import 'package:syncia/controllers/saved_collections_controller.dart';
import 'package:syncia/controllers/theme_controller.dart';
import 'package:syncia/models/chat_message.dart';
import 'package:syncia/route.dart';
import 'package:syncia/styles/size_config.dart';
import 'package:syncia/widgets/markdown_response_tile.dart';
import 'create_collection_dialog_box.dart';

class QueryTile extends StatelessWidget {
  const QueryTile({Key? key, required this.chatMessage}) : super(key: key);
  final ChatMessage chatMessage;
  _showModalBottomSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      builder: (context) {
        return GetBuilder<SavedCollectionsController>(
            init: SavedCollectionsController(),
            builder: (controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (controller.collections.isNotEmpty) ...[
                    const Text(
                      'Available collections',
                      style: TextStyle(fontSize: 12),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.collections.length,
                        itemBuilder: (context, index) {
                          final collection = controller.collections[index];
                          return ListTile(
                            title: Text(collection.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () async {
                                // add chatMessage to the collection
                                bool response = await controller
                                    .saveChatMessageToCollection(
                                        collection.id, chatMessage);
                                if (response) {
                                  Get.back();
                                  Get.snackbar("Success",
                                      "Saved to ${collection.name} collection",
                                      onTap: (_) {
                                    Get.toNamed(Routes.savedCollectionPage,
                                        arguments: collection.toMap());
                                  });
                                }
                              },
                            ),
                          );
                        })
                  ] else
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Text('No saved collections available'),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return const CreateCollectionDialogBox();
                        },
                      );
                    },
                    child: const Text(
                      'Create new collection',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              );
            });
      });

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
            child: Row(
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
                    } else if (result == 'save') {
                      _showModalBottomSheet(context);
                    } else if (result == 'delete') {
                      await ChatController.to.deleteMessage(chatMessage.id);
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
                      value: 'save',
                      child: ListTile(
                        leading: Obx(() => Icon(
                              Icons.bookmark_outline,
                              color: ThemeController.to.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            )),
                        title: const Text('Save'),
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
