import 'package:get/get.dart';
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

  Future<void> createNewCollection(SavedCollectionRoom newCollection) async {
    await databaseService.saveCollectionRoom(newCollection);
    Get.back();
    Get.toNamed(Routes.textChatPage, arguments: newCollection.toMap());
    await getChatRooms();
  }

  Future<void> deleteChatRoom(int id) async {
    await databaseService.deleteCollectionRoom(id).then((_) {
      collections.removeWhere((e) => e.id == id);
      update();
    });
  }
}
