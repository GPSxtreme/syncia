import 'package:get/get.dart';
import 'package:syncia/models/chat_message.dart';
import 'package:syncia/models/saved_collection_room.dart';
import 'package:syncia/services/local_database_service.dart';
import '../route.dart';

class SavedCollectionsController extends GetxController {
  static SavedCollectionsController get to => Get.find();
  List<SavedCollectionRoom> collections = [];
  final DatabaseService databaseService = DatabaseService();

  @override
  Future<void> onInit() async {
    super.onInit();
    await getChatRooms();
  }

  Future<void> getChatRooms() async {
    collections = await databaseService.getCollectionRooms();
    update();
  }

  Future<void> createNewCollection(String name) async {
    int id = await databaseService.createNewCollection(name);
    Get.back();
    final SavedCollectionRoom collection = SavedCollectionRoom(
        id: id, name: name, createdOn: DateTime.now().toIso8601String());
    Get.toNamed(Routes.savedCollectionPage, arguments: collection.toMap());
    await getChatRooms();
  }

  Future<void> deleteChatRoom(int id) async {
    await databaseService.deleteCollectionRoom(id).then((_) {
      collections.removeWhere((e) => e.id == id);
      update();
    });
  }

  Future<bool> saveChatMessageToCollection(
      int collectionId, ChatMessage message) async {
    try {
      await databaseService.bookMarkChatMessage(collectionId, message);
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }
}
