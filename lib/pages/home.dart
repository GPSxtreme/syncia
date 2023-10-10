import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/home_controller.dart';
import '../controllers/theme_controller.dart';
import '../widgets/text_chat_room_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          Obx(() => Switch(
                value: Get.find<ThemeController>().isDarkTheme.value,
                onChanged: (value) => Get.find<ThemeController>().toggleTheme(),
              )),
        ],
        elevation: 0.5,
      ),
      floatingActionButton: FloatingActionButton(
          child: Obx(() => Icon(
                Icons.add,
                color: ThemeController.to.isDarkTheme.value
                    ? Colors.blue
                    : Colors.white,
                size: 40,
              )),
          onPressed: () {
            HomeController.to.createTextChatRoom();
          }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              'Text chats',
              style: TextStyle(fontSize: 30),
            ),
          ),
          GetBuilder<HomeController>(
            assignId: true,
            init: HomeController(),
            autoRemove: false,
            builder: (controller) {
              if (controller.chatRooms.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.chatRooms.length,
                    itemBuilder: (context, index) {
                      return TextChatRoomTile(
                        chatRoomData: controller.chatRooms[index],
                      );
                    },
                  ),
                );
              } else if (controller.chatRooms.isEmpty &&
                  controller.initialized) {
                return const Center(
                  child: Text(
                    'No chats available',
                    style: TextStyle(fontSize: 15),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
