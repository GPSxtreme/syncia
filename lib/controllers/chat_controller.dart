// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/chat_message.dart';
import '../services/local_database_service.dart';
import '../services/open_ai_service.dart';

const int MAX_CHAR = 10000;


class ChatController extends GetxController {
  static ChatController get to => Get.find();
  List<ChatMessage> chatMessages = [];
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final DatabaseService databaseService = DatabaseService();
  final RxBool isSendingMessage = false.obs;
  final RxInt characterCount = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    inputController.addListener(_updateCharacterCount);
    chatMessages = await databaseService.getChatMessages();
    update();
  }

  @override
  void dispose() {
    inputController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _updateCharacterCount() {
    characterCount.value = inputController.text.length;
  }

  addMessage(ChatMessage message){
    chatMessages.add(message);
    update();
  }

  Future<void> sendChatMessage() async {
    if (inputController.text.isEmpty) {
      return;
    }
    isSendingMessage.value = true;
    final question = inputController.text;
    final response = await OpenAiService().chatCompletion(question.trim(), 'gpt-3.5-turbo');
    ChatMessage message = ChatMessage(
        id: response.id,
        query: question.trim(),
        response: response.choices[0].message.content.trim(),
        timestamp: DateTime.now());
    addMessage(message);
    ChatMessage readMsg = ChatMessage(
        id: response.id,
        query: question.trim(),
        response: response.choices[0].message.content.trim(),
        timestamp: DateTime.now());
    readMsg.setRead(true);
    await databaseService.saveChatMessage(readMsg);
    isSendingMessage.value = false;
    inputController.clear();
    // Scroll to the newly added query
    scrollToBottom();
  }

  scrollToBottom() async {
    // Wait for the animation to complete
    await Future.delayed(const Duration(milliseconds: 500));

    // Scroll to the bottom
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

}