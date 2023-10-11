// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:syncia/controllers/theme_controller.dart';
import 'package:syncia/services/open_ai_service.dart';
import 'package:syncia/styles/size_config.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class CreateTextChatRoomDialogBox extends StatelessWidget {
  CreateTextChatRoomDialogBox({super.key});
  final TextEditingController _nameController = TextEditingController();
  final List<String> availableModels =
      OpenAiService.models.map((e) => e.id).toList();
  final selectedModel = 'gpt-3.5-turbo'.obs;

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
                      await HomeController.to.createTextChatRoom(
                          _nameController.text.trim(), selectedModel.value);
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
              Obx(
                () => TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        labelText: 'Room Name',
                        labelStyle: TextStyle(fontSize: 14),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ThemeController.to.isDarkTheme.value
                                    ? Colors.white24
                                    : Colors.black26)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 1,
                        )))),
              ),
              const SizedBox(height: 20),
              const Text('Choose model'),
              const SizedBox(height: 10),
              Obx(() => DropdownButton(
                  isExpanded: true,
                  value: selectedModel.value,
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
                    selectedModel.value = value.toString();
                  }))
            ],
          ),
        ));
  }
}
