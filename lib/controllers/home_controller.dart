import 'package:get/get.dart';
import 'package:syncia/services/local_database_service.dart';
import '../models/chat_room_data.dart';
import '../route.dart';

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

  Future<void> createTextChatRoom(String roomName, String modelName) async {
    int roomId = await databaseService.createChatRoom(roomName, modelName);
    Get.back();
    Get.toNamed(Routes.textChatPage,
        arguments: {'roomId': roomId, 'isNew': true, 'modelId': modelName});
    await getChatRooms();
  }

  Future<void> deleteChatRoom(int id) async {
    await databaseService.deleteChatRoom(id).then((_) {
      chatRooms.removeWhere((e) => e.id == id);
      update();
    });
  }
}
