// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncia/models/chat_message.dart';
import 'package:syncia/services/local_database_service.dart';

const int INITIAL_MESSAGE_LOAD_COUNT = 10;
const int OLD_MESSAGES_FETCH_COUNT = 5;

class SavedCollectionController extends GetxController {
  final int collectionId;
  static SavedCollectionController get to => Get.find();
  RxList<ChatMessage> chatMessages = RxList<ChatMessage>();
  final DatabaseService databaseService = DatabaseService();
  final ScrollController scrollController = ScrollController();
  final RxBool showScrollToTopBtn = false.obs;
  final RxBool showScrollToBottomBtn = false.obs;
  final RxBool isInit = false.obs;

  SavedCollectionController({required this.collectionId}) {
    scrollController.addListener(_handleScrollEvent);
  }

  @override
  void onInit() async {
    _loadInitialMessages();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.removeListener(_handleScrollEvent);
    super.onClose();
  }

  Future<void> _loadInitialMessages() async {
    // Fetching the most recent 20 messages
    final messages = await databaseService.getSavedChatMessages(collectionId,
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
    final olderMessages = await databaseService.getSavedChatMessages(
        collectionId,
        end: chatMessages.length,
        limit: OLD_MESSAGES_FETCH_COUNT);

    // Check if there are no more older messages
    if (olderMessages.isEmpty) {
      return;
    }

    chatMessages.insertAll(0, olderMessages);
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

  Future<void> deleteMessage(String messageId) async {
    try {
      await databaseService
          .deleteBookMarkedChatMessage(collectionId, messageId)
          .then((_) {
        chatMessages.removeWhere((m) => m.id == messageId);
      });
    } catch (e) {
      Get.snackbar("Error", "Failed deleting message");
    }
  }
}
