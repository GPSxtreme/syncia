// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:syncia/models/image_room_message.dart';
import 'package:uuid/uuid.dart';
import '../services/local_database_service.dart';
import '../services/open_ai_service.dart';

const int MAX_CHAR = 10000;
const int INITIAL_MESSAGE_LOAD_COUNT = 10;
const int OLD_MESSAGES_FETCH_COUNT = 5;

class ImageChatController extends GetxController {
  final int roomId;
  static ImageChatController get to => Get.find();
  RxList<ImageRoomMessage> chatMessages = RxList<ImageRoomMessage>([]);
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxBool showScrollToTopBtn = false.obs;
  final RxBool showScrollToBottomBtn = false.obs;
  final DatabaseService databaseService = DatabaseService();
  final RxBool isSendingMessage = false.obs;
  final RxInt characterCount = 0.obs;
  final RxBool isInit = false.obs;

  ImageChatController({required this.roomId}) {
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
    final messages = await databaseService.getImageChatMessages(roomId,
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
    final olderMessages = await databaseService.getImageChatMessages(roomId,
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

  void addMessage(ImageRoomMessage message) {
    chatMessages.add(message);
  }

  Future<void> sendChatMessage() async {
    if (inputController.text.isEmpty) {
      return;
    }

    isSendingMessage.value = true;
    final prompt = inputController.text;

    try {
      final response = await OpenAiService.generateImageOnPrompt(prompt);
      List<String> imageLinks = response.data
          .map((e) => e.url) // Mapping urls
          .whereType<
              String>() // Filtering out null values and ensuring every element is a String
          .toList(); // Converting the Iterable to a List

      final chatMessage = ImageRoomMessage(
          id: const Uuid().v4(),
          query: prompt,
          timestamp: response.created,
          imageLinks: imageLinks);
      await databaseService.saveImageChatMessage(roomId, chatMessage).then((_) {
        addMessage(chatMessage);
        isSendingMessage.value = false;
        inputController.clear();
        scrollToBottom();
      });
    } catch (error) {
      Get.snackbar('Error', 'Failed to process request.');
      isSendingMessage.value = false;
    }
  }

  void addOrUpdateMessage(ImageRoomMessage message) {
    int index = chatMessages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      chatMessages[index] = message;
    } else {
      chatMessages.add(message);
    }
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
      await databaseService.deleteImageChatMessage(roomId, messageId).then((_) {
        chatMessages.removeWhere((m) => m.id == messageId);
      });
    } catch (e) {
      Get.snackbar("Error", "Failed deleting message");
    }
  }
}
