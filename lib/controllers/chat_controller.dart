// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:syncia/models/chat_message.dart';
import 'package:syncia/services/local_database_service.dart';
import 'package:syncia/services/open_ai_service.dart';
import '../route.dart';
import 'package:flutter/material.dart';

const int MAX_CHAR = 10000;
const int INITIAL_MESSAGE_LOAD_COUNT = 10;
const int OLD_MESSAGES_FETCH_COUNT = 5;

class ChatController extends GetxController {
  final int roomId;
  final String modelId;
  static ChatController get to => Get.find();
  RxList<ChatMessage> chatMessages = RxList<ChatMessage>();
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxBool showScrollToTopBtn = false.obs;
  final RxBool showScrollToBottomBtn = false.obs;
  final DatabaseService databaseService = DatabaseService();
  final RxBool isSendingMessage = false.obs;
  final RxInt characterCount = 0.obs;
  final RxBool isInit = false.obs;

  ChatController({required this.roomId, required this.modelId}) {
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
    final messages = await databaseService.getChatMessages(roomId,
        limit: INITIAL_MESSAGE_LOAD_COUNT);
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
          _loadOlderMessages();
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
        end: chatMessages.length, limit: OLD_MESSAGES_FETCH_COUNT);

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

  // Sends a chat message asynchronously.
  Future<void> sendChatMessage() async {
    final messageText = inputController.text.trim();
    if (messageText.isEmpty) {
      return;
    }

    _startMessageSending();

    try {
      final currentChatHistory = _buildChatHistory();
      final responseStream =
          await OpenAiService.streamChatCompletionWithHistory(
        messageText,
        modelId,
        currentChatHistory,
      );

      if (responseStream != null) {
        await _processResponseStream(responseStream, messageText);
      } else {
        _showErrorSnackbar('Failed to process request.');
      }
    } catch (error) {
      _handleSendError(error);
    } finally {
      isSendingMessage.value = false;
    }
  }

  void _updateChatUI(String question, String response, String id) {
    final message = ChatMessage(
        id: id, query: question, response: response, timestamp: DateTime.now());
    addOrUpdateMessage(message);
    scrollToBottom(addDelay: true, delay: 250);
  }

  // Processes the stream of OpenAIStreamChatCompletionModel responses.
  Future<void> _processResponseStream(
      Stream<OpenAIStreamChatCompletionModel>? stream, String question) async {
    if (stream == null) {
      _showErrorSnackbar('No response stream available.');
      return;
    }

    String? messageId;
    final StringBuffer streamedResponse = StringBuffer();

    await for (final OpenAIStreamChatCompletionModel response in stream) {
      messageId = response
          .id; // Assuming 'id' exists in OpenAIStreamChatCompletionModel
      // Process each piece of content in the response's choices. This assumes a similar structure to what was initially expected.
      response.choices.first.delta.content?.forEach((element) {
        streamedResponse.write(
            element?.text ?? ''); // Safely handle null 'element' and 'text'
      });

      _updateChatUI(question, streamedResponse.toString(), messageId);
    }

    if (messageId != null) {
      final ChatMessage finalMessage = ChatMessage(
        id: messageId,
        query: question,
        response: streamedResponse.toString(),
        timestamp: DateTime.now(),
      );
      databaseService.saveChatMessage(roomId, finalMessage);
      scrollToBottom();
    }
  }

// Starts sending a message by setting the appropriate flags and clearing the input controller.
  void _startMessageSending() {
    isSendingMessage.value = true;
    inputController.clear();
  }

// Builds the chat history from the current chat messages to be used for the chat completion request.
  List<OpenAIChatCompletionChoiceMessageModel> _buildChatHistory() {
    return chatMessages.expand((message) {
      final userMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(message.query)
        ],
        role: OpenAIChatMessageRole.user,
      );
      final systemMessage = message.response.isNotEmpty
          ? OpenAIChatCompletionChoiceMessageModel(
              content: [
                OpenAIChatCompletionChoiceMessageContentItemModel.text(
                    message.query)
              ],
              role: OpenAIChatMessageRole.system,
            )
          : null;
      return systemMessage != null
          ? [userMessage, systemMessage]
          : [userMessage];
    }).toList();
  }

// Displays an error snackbar with the provided message.
  void _showErrorSnackbar(String message) {
    Get.snackbar('Error', message, icon: const Icon(Icons.error));
  }

// Handles errors during the message sending process.
  void _handleSendError(dynamic error) {
    final errorMessage = error is MissingApiKeyException
        ? 'API key is not set. Please go to settings and input OpenAI key.'
        : error.toString();
    Get.snackbar(
        'Error', 'Failed to process request.\nClick here to view full log',
        icon: const Icon(Icons.error), onTap: (_) {
      Get.toNamed(Routes.viewErrorPage, arguments: {'log': errorMessage});
    });
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

  Future<void> deleteMessage(String messageId) async {
    try {
      await databaseService.deleteChatMessage(roomId, messageId).then((_) {
        chatMessages.removeWhere((m) => m.id == messageId);
      });
    } catch (e) {
      Get.snackbar("Error", "Failed deleting message");
    }
  }
}
