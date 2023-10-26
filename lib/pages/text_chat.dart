// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:get/get.dart';
import 'package:syncia/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncia/models/chat_room_data.dart';
import 'package:syncia/widgets/query_tile.dart';
import 'package:syncia/widgets/text_chat_textfield.dart';

import '../styles/size_config.dart';

class TextChatPage extends StatefulWidget {
  const TextChatPage({Key? key}) : super(key: key);

  @override
  State<TextChatPage> createState() => _TextChatPageState();
}

class _TextChatPageState extends State<TextChatPage> {
  final ChatRoomData chatRoomData = ChatRoomData.fromMap(Get.arguments);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text(chatRoomData.modelName),
      ),
      body: GetX<ChatController>(
        assignId: true,
        init: ChatController(
            roomId: chatRoomData.id, modelId: chatRoomData.modelName),
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
                          return QueryTile(
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
                        child: TextChatTextField(),
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
