import 'package:get/get.dart';
import 'package:syncia/services/local_database_service.dart';
import '../models/chat_room_data.dart';
import '../route.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  List<ChatRoomData> chatRooms = [];
  final DatabaseService databaseService = DatabaseService();

  @override
  Future<void> onInit() async {
    super.onInit();
    await getChatRooms();
  }

  Future<void> getChatRooms() async {
    chatRooms = await databaseService.getChatRooms();
    update();
  }

  Future<void> createTextChatRoom() async {
    TextEditingController roomNameController = TextEditingController();


    // Function to proceed with room creation
    Future<void> proceedWithCreation() async {
      if (roomNameController.text.isNotEmpty) {
        int roomId = await databaseService.createChatRoom(roomNameController.text);
        Get.toNamed(Routes.textChatPage, arguments: {'roomId': roomId, 'isNew': true});
        await getChatRooms();
        Get.back();  // Close the dialog
      } else {
        Get.snackbar('Error', 'Room name cannot be empty!');
      }
    }

    Get.defaultDialog(
      title: 'Create chat room',
      radius: 12,
      titlePadding: const EdgeInsets.only(top: 18.0),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: roomNameController,
              decoration: const InputDecoration(
                labelText: 'Room Name',
                labelStyle: TextStyle(fontSize: 14),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: proceedWithCreation,
                  child: const Text('Create',style: TextStyle(color: Colors.white),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> deleteChatRoom(int id) async {
    await databaseService.deleteChatRoom(id).then(
        (_){
          chatRooms.removeWhere((e) => e.id == id);
          update();
        }
    );
  }
}
