import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:syncia/controllers/chat_controller.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/theme_controller.dart';

class TextChatTextField extends StatelessWidget {
  TextChatTextField({super.key});
  final controller = ChatController.to;
  @override
  Widget build(BuildContext context) {
    return Obx(
        (){
          // get colors according to theme
          final containerBackgroundColor = ThemeController.to.isDarkTheme.value ? HexColor('#212121') : Colors.white;
          final containerBorderColor = ThemeController.to.isDarkTheme.value ? Colors.white10 : Colors.grey.withOpacity(0.3);
          final hintTextColor = ThemeController.to.isDarkTheme.value ? Colors.white70 : Colors.grey.withOpacity(0.8);
          final elevatedButtonColor = ThemeController.to.isDarkTheme.value ? Colors.white12 : Colors.blue;
          final elevatedButtonTextColor = ThemeController.to.isDarkTheme.value ? Colors.blue : Colors.white;
          return Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: containerBackgroundColor,
              border: Border.all(width: 1.0,color: containerBorderColor),
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
                                color: hintTextColor),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: elevatedButtonColor,
                      ),
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
                          ? Row(
                        children: [
                          Text(
                            'Send',
                            style: TextStyle(
                              color: elevatedButtonTextColor,
                            )
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.send_rounded,
                            size: 15,
                            color: elevatedButtonTextColor,
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
          );
        }
    );
  }
}
