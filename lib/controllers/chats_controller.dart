import 'package:get/get.dart';
import 'package:syncia/models/chat_room_data.dart';
import 'package:syncia/services/local_database_service.dart';

import '../route.dart';

class ChatsController extends GetxController {
  static ChatsController get to => Get.find();
  List<ChatRoomData> chatRooms = [];
  final DatabaseService databaseService = DatabaseService();

  @override
  Future<void> onInit() async {
    super.onInit();
    await getChatRooms();
  }

  Future<void> getChatRooms() async {
    await databaseService.getChatRooms().then((value) {
      chatRooms = value;
      update();
    });
  }

  Future<void> createTextChatRoom(String roomName, String modelName) async {
    final newRoom = await databaseService.createChatRoom(roomName, modelName);
    Get.back();
    Get.toNamed(Routes.textChatPage, arguments: newRoom.toMap());
    await getChatRooms();
  }

  Future<void> deleteChatRoom(int id) async {
    await databaseService.deleteChatRoom(id).then((_) {
      chatRooms.removeWhere((e) => e.id == id);
      update();
    });
  }
}
