// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/chat_controller.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncia/models/chat_message.dart';
import 'package:syncia/widgets/query_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/local_database_service.dart';

String? MY_API_KEY = dotenv.env['API_KEY'];
const int MAX_WORDS = 10000;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _inputController = TextEditingController();
  int _characterCount = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isSendingMessage = false;
  final DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_updateCharacterCount);
  }


  void _updateCharacterCount() {
    setState(() {
      _characterCount = _inputController.text.length;
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendChatMessage() async {
    if (_isSendingMessage) return;
    setState(() {
      _isSendingMessage = true;
    });
    final question = _inputController.text;
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $MY_API_KEY',
    };

    final requestBody = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': 'You are a user'},
        {'role': 'user', 'content': question.trim()},
      ],
    });

    await Future.delayed(const Duration(
        milliseconds:
        0)); // Add a delay of n seconds before sending the request

    final response = await http.post(url, headers: headers, body: requestBody);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final List<Map<String, dynamic>> choices =
      responseBody['choices'].cast<Map<String, dynamic>>();

      for (final choice in choices) {
        final String responseText = choice['message']['content'];
        ChatMessage message = ChatMessage(
            id: const Uuid().v4(),
            query: question.trim(),
            response: responseText.trim(),
            timestamp: DateTime.now());
        ChatController.to.addMessage(message);
        ChatMessage readMsg = ChatMessage(
            id: const Uuid().v4(),
            query: question.trim(),
            response: responseText.trim(),
            timestamp: DateTime.now());
        readMsg.setRead(true);
        await databaseService.saveChatMessage(readMsg);
      }
    }
    setState(() {
      _isSendingMessage = false;
    });
    _inputController.clear();
    // Scroll to the newly added query
    _scrollToBottomWithDelay();
  }

  Future<void> _scrollToBottomWithDelay() async {
    // Wait for the animation to complete
    await Future.delayed(const Duration(milliseconds: 500));

    // Scroll to the bottom
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/svgs/app_bar_logo.svg',
              height: 30,
              width: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              width: 10.0,
            ),
            const Text(
              'Syncia',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: GetBuilder<ChatController>(
        assignId: true,
        init: ChatController(),
        builder: (controller) {
          return Stack(
            children: [
              controller.chatMessages.isNotEmpty
                  ? ListView.builder(
                padding: EdgeInsets.only(bottom: device.size.height * 0.2),
                shrinkWrap: true,
                itemCount: controller.chatMessages.length,
                reverse: false,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final query = controller.chatMessages[index].query;
                  final response = controller.chatMessages[index].response;
                  bool isLast = index == controller.chatMessages.length - 1;
                  bool isRead = false;
                  if (controller.chatMessages[index].read == false) {
                    controller.chatMessages[index].setRead(true);
                  } else {
                    isRead = true;
                  }
                  return QueryTile(
                      isLast: isLast,
                      isRead: isRead,
                      query: query,
                      response: response);
                },
              )
                  : controller.chatMessages.isEmpty ? Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Center(
                        child: Image.asset(
                          "assets/pngs/little-bot.png",
                          height: 300,
                          width: 300,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Start a new conversation ✨",
                      style: TextStyle(color: Colors.black38, fontSize: 23),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Type your message at the bottom\nand press send button.",
                      style: TextStyle(color: Colors.black38, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ) : const SpinKitPulse(color: Colors.blue, size: 30,),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.3), width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(left: 8.0, bottom: 4.0),
                                child: TextField(
                                  controller: _inputController,
                                  minLines: 1,
                                  maxLines: 8,
                                  decoration: InputDecoration(
                                    hintText: "Type your message here..",
                                    hintStyle: TextStyle(
                                        color: Colors.grey.withOpacity(0.8)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              '$_characterCount / ${MAX_WORDS.toString()}',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: _characterCount > MAX_WORDS
                                      ? Colors.red
                                      : null),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: _inputController.text.isNotEmpty &&
                                  _characterCount < MAX_WORDS
                                  ? _sendChatMessage
                                  : null,
                              child: !_isSendingMessage
                                  ? const Row(
                                children: [
                                  Text('Send'),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 15,
                                  )
                                ],
                              )
                                  : const SpinKitPulse(
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
