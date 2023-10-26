import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/saved_collection_controller.dart';
import 'package:syncia/models/saved_collection_room.dart';
import 'package:syncia/styles/size_config.dart';
import 'package:syncia/widgets/saved_query_tile.dart';

class SavedCollectionPage extends StatelessWidget {
  const SavedCollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SavedCollectionRoom collection =
        SavedCollectionRoom.fromMap(Get.arguments);
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(collection.name),
      ),
      body: GetX<SavedCollectionController>(
          init: SavedCollectionController(collectionId: collection.id),
          builder: (controller) {
            if (!controller.isInit.value) {
              controller.scrollToBottom(useAnimation: false);
              controller.isInit.value = true;
            }

            return Stack(
              children: [
                controller.chatMessages.isNotEmpty
                    ? Scrollbar(
                        controller: controller.scrollController,
                        interactive: true,
                        thickness: 5.0,
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                              bottom: SizeConfig.screenHeight! * 0.2),
                          shrinkWrap: true,
                          reverse: false,
                          itemCount: controller.chatMessages.length,
                          controller: controller.scrollController,
                          itemBuilder: (context, index) {
                            final chatMessage = controller.chatMessages[index];
                            return SavedQueryTile(
                              key: ValueKey(chatMessage.id),
                              chatMessage: chatMessage,
                            );
                          },
                        ),
                      )
                    : controller.chatMessages.isEmpty && controller.initialized
                        ? Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Image.asset(
                                  "assets/pngs/little-bot.png",
                                  height: 300,
                                  width: 300,
                                )),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "No saved messages",
                                  style: TextStyle(fontSize: 23),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "Your saved chat messages will appear here",
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : const SpinKitPulse(
                            color: Colors.blue,
                            size: 30,
                          ),
                if (controller.chatMessages.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (controller.showScrollToTopBtn.value)
                            RawMaterialButton(
                              onPressed: () {
                                controller.scrollToTop(addDelay: false);
                              },
                              elevation: 2.0,
                              fillColor: Colors.blue,
                              padding: const EdgeInsets.all(3.0),
                              shape: const CircleBorder(),
                              child: const Icon(
                                Icons.keyboard_arrow_up,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          if (controller.showScrollToBottomBtn.value)
                            RawMaterialButton(
                              onPressed: () {
                                controller.scrollToBottom(addDelay: false);
                              },
                              elevation: 2.0,
                              fillColor: Colors.blue,
                              padding: const EdgeInsets.all(3.0),
                              shape: const CircleBorder(),
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          )
                        ]),
                  ),
              ],
            );
          }),
    );
  }
}
