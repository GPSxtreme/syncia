import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/theme_controller.dart';
import 'package:syncia/widgets/markdown_response_tile.dart';

class QueryTile extends StatelessWidget {
  const QueryTile(
      {Key? key,
      required this.isLast,
      required this.isRead,
      required this.query,
      required this.response})
      : super(key: key);
  final bool isLast;
  final bool isRead;
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          color: Colors.blue,
                          tooltip: 'copy response',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: response));
                          },
                          icon: Obx(() => Icon(
                                Icons.copy,
                                color: ThemeController.to.isDarkTheme.value
                                    ? Colors.white
                                    : Colors.black,
                              ))),
                    )
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
