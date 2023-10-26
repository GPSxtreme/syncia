import 'package:get/get.dart';
import 'package:syncia/models/image_chat_room_data.dart';

import '../route.dart';
import '../services/local_database_service.dart';

class ImageChatsController extends GetxController {
  static ImageChatsController get to => Get.find();
  List<ImageChatRoomData> chatRooms = [];
  final DatabaseService databaseService = DatabaseService();

  @override
  Future<void> onInit() async {
    super.onInit();
    await getChatRooms();
  }

  Future<void> getChatRooms() async {
    chatRooms = await databaseService.getImageChatRooms();
    update();
  }

  Future<void> createImageChatRoom(String roomName) async {
    final newRoom = await databaseService.createImageChatRoom(roomName);
    Get.back();
    Get.toNamed(Routes.imageChatPage, arguments: newRoom.toJson());
    await getChatRooms();
  }

  Future<void> deleteChatRoom(int id) async {
    await databaseService.deleteImageChatRoom(id).then((_) {
      chatRooms.removeWhere((e) => e.id == id);
      update();
    });
  }
}
