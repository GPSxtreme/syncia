import 'package:flutter/material.dart';
import 'package:syncia/controllers/chats_controller.dart';
import 'package:syncia/services/open_ai_service.dart';
import 'package:syncia/styles/size_config.dart';
import 'package:get/get.dart';

class CreateTextChatRoomDialogBox extends StatefulWidget {
  const CreateTextChatRoomDialogBox({super.key});

  @override
  State<CreateTextChatRoomDialogBox> createState() =>
      _CreateTextChatRoomDialogBoxState();
}

class _CreateTextChatRoomDialogBoxState
    extends State<CreateTextChatRoomDialogBox> {
  final TextEditingController _nameController = TextEditingController();

  // map all the ids of elements in the OpenAiService.models staring with gpt
  final List<String> availableModels = OpenAiService.models
      .map((e) => e.id)
      .where((e) => e.startsWith('gpt'))
      .toList();

  String selectedModel = 'gpt-3.5-turbo';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        titlePadding: EdgeInsets.zero,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        actionsAlignment: MainAxisAlignment.start,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        title: Container(
          width: SizeConfig.screenWidth! * 0.85,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  splashRadius: 15,
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                  onPressed: () {
                    Get.back(); // Close the dialog
                  },
                ),
              ),
              const Center(
                child: Text(
                  'New chat room',
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  splashRadius: 15,
                  icon: const Icon(
                    Icons.check,
                    size: 20,
                  ),
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty &&
                        selectedModel.isNotEmpty) {
                      try {
                        await ChatsController.to.createTextChatRoom(
                            _nameController.text.trim(), selectedModel);
                      } catch (e) {
                        Get.snackbar('Error', e.toString());
                      }
                    } else {
                      Get.snackbar('Error', 'Room name cannot be empty!');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Room name',
                  )),
              const SizedBox(height: 20),
              const Text('Choose model'),
              const SizedBox(height: 10),
              DropdownButton(
                  isExpanded: true,
                  value: selectedModel,
                  menuMaxHeight: SizeConfig.blockSizeVertical! * 30,
                  items: availableModels
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedModel = value.toString();
                    });
                  })
            ],
          ),
        ));
  }
}
