import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/chat_message.dart';
import '../services/local_database_service.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find();
  List<ChatMessage> chatMessages = [];
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final DatabaseService databaseService = DatabaseService();

  @override
  Future<void> onInit() async {
    super.onInit();
    chatMessages = await databaseService.getChatMessages();
    update();
  }

  addMessage(ChatMessage message){
    chatMessages.add(message);
    update();
  }
}