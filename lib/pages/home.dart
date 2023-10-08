// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:get/get.dart';
import 'package:syncia/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncia/widgets/query_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/svgs/app_bar_logo.svg',
              height: 30,
              width: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              width: 10.0,
            ),
            const Text(
              'Syncia',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: GetBuilder<ChatController>(
        assignId: true,
        init: ChatController(),
        builder: (controller) {
          return Stack(
            children: [
              controller.chatMessages.isNotEmpty
                  ? ListView.builder(
                      padding:
                          EdgeInsets.only(bottom: device.size.height * 0.2),
                      shrinkWrap: true,
                      itemCount: controller.chatMessages.length,
                      reverse: false,
                      controller: controller.scrollController,
                      itemBuilder: (context, index) {
                        final query = controller.chatMessages[index].query;
                        final response =
                            controller.chatMessages[index].response;
                        bool isLast =
                            index == controller.chatMessages.length - 1;
                        bool isRead = false;
                        if (controller.chatMessages[index].read == false) {
                          controller.chatMessages[index].setRead(true);
                        } else {
                          isRead = true;
                        }
                        return QueryTile(
                            isLast: isLast,
                            isRead: isRead,
                            query: query,
                            response: response);
                      },
                    )
                  : controller.chatMessages.isEmpty
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
                                style: TextStyle(
                                    color: Colors.black38, fontSize: 23),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Type your message at the bottom\nand press send button.",
                                style: TextStyle(
                                    color: Colors.black38, fontSize: 16),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.3), width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 4.0),
                                child: TextField(
                                  controller: controller.inputController,
                                  minLines: 1,
                                  maxLines: 8,
                                  decoration: InputDecoration(
                                    hintText: "Type your message here..",
                                    hintStyle: TextStyle(
                                        color: Colors.grey.withOpacity(0.8)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Obx(() => Text(
                                  '${controller.characterCount.value} / ${MAX_CHAR.toString()}',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color:
                                          controller.characterCount > MAX_CHAR
                                              ? Colors.red
                                              : null),
                                )),
                            const Spacer(),
                            Obx(() => ElevatedButton(
                                  onPressed: !controller
                                              .isSendingMessage.value &&
                                          controller.characterCount < MAX_CHAR
                                      ? () {
                                          // close keyboard
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          // send message
                                          controller.sendChatMessage();
                                        }
                                      : null,
                                  child: !controller.isSendingMessage.value
                                      ? const Row(
                                          children: [
                                            Text(
                                              'Send',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Icon(
                                              Icons.send_rounded,
                                              color: Colors.white,
                                              size: 15,
                                            )
                                          ],
                                        )
                                      : const SpinKitPulse(
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
