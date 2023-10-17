import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:syncia/controllers/image_chat_controller.dart';
import 'package:syncia/models/image_room_message.dart';
import 'package:get/get.dart';

import '../controllers/theme_controller.dart';
import '../route.dart';
import '../styles/size_config.dart';

class ImageChatTile extends StatelessWidget {
  const ImageChatTile({super.key, required this.message});
  final ImageRoomMessage message;
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    SizeConfig().init(context);
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
        SizedBox(
          height: SizeConfig.screenHeight! * 0.5,
          child: Scrollbar(
            controller: scrollController,
            interactive: true,
            thickness: 5.0,
            child: ListView.builder(
                controller: scrollController,
                itemCount: message.imageLinks.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.imageFullScreenPage,
                          arguments: message.toMap());
                    },
                    child: CachedNetworkImage(
                      imageUrl: message.imageLinks[index],
                      cacheKey: message.imageLinks[index].split('/').last,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, progress) {
                        return SizedBox(
                          width: SizeConfig.screenWidth,
                          child: Center(
                              heightFactor: 5,
                              child: CircularProgressIndicator(
                                  value: progress.progress)),
                        );
                      },
                      errorWidget: (context, url, error) => Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal! * 35,
                            top: SizeConfig.blockSizeVertical! * 15),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Failed loading image")
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        )
      ],
    );
  }
}
