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

  ChatController({required this.roomId, this.isNew = false}) {
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
    final messages = await databaseService.getChatMessages(roomId, limit: 20);
    // Reversing the list so the latest message is at the bottom
    chatMessages.addAll(messages.toList());
  }

  void _handleScrollEvent() {
    final double totalExtent = scrollController.position.maxScrollExtent;
    final double currentOffset = scrollController.position.pixels;

    // Calculate the thresholds based on percentages
    final double topThreshold = totalExtent * 0.15; // 15% from the top
    final double bottomThreshold = totalExtent * 0.85; // 85% from the bottom
    if (scrollController.hasClients) {
      if (currentOffset <= topThreshold) {
        // The user is in the top 20% of the list
        showScrollToTopBtn.value = false;
        showScrollToBottomBtn.value = true;
        if (scrollController.position.atEdge &&
            scrollController.position.pixels == 0) {
          _loadAndPositionMessages(); // Load more messages when at the top
        }
      } else if (currentOffset >= bottomThreshold) {
        // The user is in the bottom 15% of the list
        showScrollToTopBtn.value = true;
        showScrollToBottomBtn.value = false;
      } else {
        // The user is somewhere in between the top 15% and bottom 15%
        showScrollToTopBtn.value = true;
        showScrollToBottomBtn.value = true;
      }
    } else {
      showScrollToTopBtn.value = false;
      showScrollToBottomBtn.value = false;
    }
  }

  Future<void> _loadAndPositionMessages() async {
    double previousScrollHeight = scrollController.position.maxScrollExtent;

    await _loadOlderMessages();

    double newScrollHeight = scrollController.position.maxScrollExtent;

    // This will keep the scroll position right at the top of the newly loaded messages.
    scrollController.jumpTo(
        scrollController.offset + (newScrollHeight - previousScrollHeight));
  }

  Future<void> _loadOlderMessages() async {
    final olderMessages = await databaseService.getChatMessages(roomId,
        end: chatMessages.length, limit: 20);

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

    // Generating the chat history
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
      // Assuming OpenAiService is a Singleton
      final response = await OpenAiService().chatCompletionWithHistory(
          question.trim(), 'gpt-3.5-turbo', currentChatHistory);

      // Message for animation
      ChatMessage animatedMessage = ChatMessage(
          id: response.id,
          query: question.trim(),
          response: response.choices[0].message.content.trim(),
          timestamp: DateTime.now(),
          read: false);

      addMessage(animatedMessage);

      // Message to store to database
      ChatMessage storedMessage = ChatMessage(
          id: response.id,
          query: question.trim(),
          response: response.choices[0].message.content.trim(),
          timestamp: DateTime.now(),
          read: true);

      await databaseService.saveChatMessage(roomId, storedMessage);

      if (isNew) {
        // set room name
      }

      inputController.clear();

      // Scroll to the newly added query
      scrollToBottom();
    } catch (error) {
      Exception("Error sending chat message: $error");
      // TODO: Maybe show a user-friendly error message using a dialog or a snackbar.
    } finally {
      isSendingMessage.value = false;
    }
  }

  Future<void> scrollToBottom({bool addDelay = true}) async {
    // Wait for the animation to complete
    if (addDelay) {
      await Future.delayed(const Duration(milliseconds: 200));
    }

    // Scroll to the bottom
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
