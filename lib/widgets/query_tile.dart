import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/theme_controller.dart';
import 'package:syncia/widgets/markdown_response_tile.dart';

class QueryTile extends StatelessWidget {
  const QueryTile({Key? key, required this.query, required this.response})
      : super(key: key);
  final String query;
  final String response;

  @override
  Widget build(BuildContext context) {
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
                        query,
                        style: const TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.normal),
                      ),
                    )),
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      onSelected: (String result) {
                        if (result == 'copy') {
                          Clipboard.setData(ClipboardData(text: response));
                          Get.snackbar('Added to clipboard', 'Response copied',
                              icon: const Icon(Icons.check),
                              duration: const Duration(seconds: 2),
                              snackPosition: SnackPosition.BOTTOM);
                        } else if (result == 'save') {
                          // Implement your logic for save
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
          title: MarkdownResponseTile(response: response),
        ),
      ],
    );
  }
}
