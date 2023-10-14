// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/chat_message.dart';
import '../services/local_database_service.dart';
import '../services/open_ai_service.dart';

const int MAX_CHAR = 10000;

class ChatController extends GetxController {
  final int roomId;
  final String modelId;
  final bool isNew;
  static ChatController get to => Get.find();
  RxList<ChatMessage> chatMessages = RxList<ChatMessage>();
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final DatabaseService databaseService = DatabaseService();
  final RxBool isSendingMessage = false.obs;
  final RxInt characterCount = 0.obs;
  final RxBool showScrollToTopBtn = false.obs;
  final RxBool showScrollToBottomBtn = false.obs;
  final RxBool isInit = false.obs;
  final RxBool isFetchingOldChat = false.obs;

  ChatController(
      {required this.roomId, this.isNew = false, required this.modelId}) {
    inputController.addListener(_updateCharacterCount);
    scrollController.addListener(_handleScrollEvent);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadInitialMessages();
    // This ensures that the ListView scrolls to the bottom when new messages are added.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _loadInitialMessages() async {
    // Fetching the most recent 20 messages
    final messages = await databaseService.getChatMessages(roomId, limit: 5);
    // Reversing the list so the latest message is at the bottom
    chatMessages.addAll(messages.toList());
  }

  void _handleScrollEvent() {
    final double totalExtent = scrollController.position.maxScrollExtent;
    final double currentOffset = scrollController.position.pixels;

    // Calculate the thresholds based on percentages
    final double topThreshold = totalExtent * 0.20; // x% from the top
    final double bottomThreshold = totalExtent * 0.85; // y% from the bottom
    if (scrollController.hasClients) {
      if (currentOffset <= topThreshold) {
        // The user is in the top x% of the list
        showScrollToTopBtn.value = false;
        showScrollToBottomBtn.value = true;
        if (currentOffset == 0) {
          isFetchingOldChat.value = true;
          _loadOlderMessages().then((_) => isFetchingOldChat.value = false);
        }
      } else if (currentOffset >= bottomThreshold) {
        // The user is in the bottom x% of the list
        showScrollToTopBtn.value = true;
        showScrollToBottomBtn.value = false;
      } else {
        // The user is somewhere in between the top x% and bottom y%
        showScrollToTopBtn.value = true;
        showScrollToBottomBtn.value = true;
      }
    } else {
      showScrollToTopBtn.value = false;
      showScrollToBottomBtn.value = false;
    }
  }

  Future<void> _loadOlderMessages() async {
    final olderMessages = await databaseService.getChatMessages(roomId,
        end: chatMessages.length, limit: 5);

    // Check if there are no more older messages
    if (olderMessages.isEmpty) {
      return;
    }

    chatMessages.insertAll(0, olderMessages);
  }

  @override
  void dispose() {
    inputController.removeListener(_updateCharacterCount);
    scrollController.removeListener(_handleScrollEvent);
    inputController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _updateCharacterCount() {
    characterCount.value = inputController.text.length;
  }

  void addMessage(ChatMessage message) {
    chatMessages.add(message);
  }

  Future<void> sendChatMessage() async {
    if (inputController.text.isEmpty) {
      return;
    }

    isSendingMessage.value = true;
    final question = inputController.text;

    var currentChatHistory = chatMessages
        .expand((message) => [
              OpenAIChatCompletionChoiceMessageModel(
                content: message.query,
                role: OpenAIChatMessageRole.user,
              ),
              if (message.response.isNotEmpty)
                OpenAIChatCompletionChoiceMessageModel(
                  content: message.response,
                  role: OpenAIChatMessageRole.system,
                ),
            ])
        .toList();

    try {
      final stream = await OpenAiService.streamChatCompletionWithHistory(
          question.trim(), modelId, currentChatHistory);

      StringBuffer streamedResponse = StringBuffer();

      if (stream != null) {
        String? id;
        stream.listen((response) {
          id = response.id;
          streamedResponse.write(response.choices.first.delta.content!);

          ChatMessage message = ChatMessage(
              id: id!,
              query: question.trim(),
              response: streamedResponse.toString(),
              timestamp: DateTime.now(),
              read: false);

          addOrUpdateMessage(message);
          scrollToBottom(addDelay: true, delay: 250);
        }, onDone: () {
          if (id != null) {
            ChatMessage finalMessage = ChatMessage(
                id: id!,
                query: question.trim(),
                response: streamedResponse.toString(),
                timestamp: DateTime.now(),
                read: true);
            databaseService.saveChatMessage(roomId, finalMessage);
            inputController.clear();
            scrollToBottom();
          }
          isSendingMessage.value = false;
        }, onError: (error) {
          Get.snackbar('Error', 'Failed to process request.');
          isSendingMessage.value = false;
        });
      } else {
        Get.snackbar('Error', 'Failed to process request.');
      }
    } catch (error) {
      Get.snackbar('Error', 'Failed to process request.');
      isSendingMessage.value = false;
    }
  }

  void addOrUpdateMessage(ChatMessage message) {
    int index = chatMessages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      chatMessages[index] = message;
    } else {
      chatMessages.add(message);
    }
    update();
  }

  Future<void> scrollToBottom(
      {bool addDelay = true, int delay = 200, bool useAnimation = true}) async {
    // Wait for the animation to complete
    if (addDelay) {
      await Future.delayed(Duration(milliseconds: delay));
    }
    // hey modify logic in this if.
    if (scrollController.hasClients) {
      // Scroll to the bottom
      if (useAnimation) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        scrollController.jumpTo(
          scrollController.position.maxScrollExtent,
        );
      }
    }
  }

  Future<void> scrollToTop({bool addDelay = true}) async {
    // Wait for the animation to complete
    if (addDelay) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    // Scroll to the top
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> loadMoreMessages() async {
    double scrollPositionBeforeLoading = scrollController.position.pixels;

    // Load more messages. This should add the messages to the start/top of the list.
    await _loadOlderMessages();

    // Calculate the new scroll position.
    double newScrollPosition =
        scrollController.position.maxScrollExtent - scrollPositionBeforeLoading;

    // Jump to the new scroll position.
    scrollController.jumpTo(newScrollPosition);
  }
}
