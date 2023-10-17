import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/image_chat_controller.dart';
import 'package:syncia/models/image_chat_room_data.dart';
import 'package:syncia/widgets/image_chat_text_field.dart';
import '../styles/size_config.dart';
import '../widgets/image_chat_tile.dart';

class ImageChatPage extends StatefulWidget {
  const ImageChatPage({super.key});

  @override
  State<ImageChatPage> createState() => _ImageChatPageState();
}

class _ImageChatPageState extends State<ImageChatPage> {
  final ImageChatRoomData chatRoomData =
      ImageChatRoomData.fromJson(Get.arguments);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(chatRoomData.name),
        elevation: 0.5,
      ),
      body: GetX<ImageChatController>(
        assignId: true,
        init: ImageChatController(
          roomId: chatRoomData.id,
        ),
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
                          return ImageChatTile(
                            key: ValueKey(chatMessage.id),
                            message: chatMessage,
                          );
                        },
                      ),
                    )
                  : controller.chatMessages.isEmpty && controller.initialized
                      ? Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
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
                                "Start a new conversation ✨",
                                style: TextStyle(fontSize: 23),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Type your message at the bottom\nand press send button.",
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
              Align(
                alignment: Alignment.bottomCenter,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ImageChatTextField(),
                      )
                    ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
