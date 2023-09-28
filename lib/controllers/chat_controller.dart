import 'package:get/get.dart';
import '../models/chat_message.dart';
import '../services/local_database_service.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find();
  List<ChatMessage> chatMessages = [];

  @override
  Future<void> onInit() async {
    super.onInit();
    chatMessages = await DatabaseService().getChatMessages();
    update();
  }

  addMessage(ChatMessage message){
    chatMessages.add(message);
    update();
  }
}