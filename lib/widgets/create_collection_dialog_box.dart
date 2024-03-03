import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncia/controllers/saved_collections_controller.dart';
import 'package:syncia/controllers/theme_controller.dart';
import '../styles/size_config.dart';

class CreateCollectionDialogBox extends StatelessWidget {
  const CreateCollectionDialogBox({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final nameController = TextEditingController();
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
                'New collection',
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
                  if (nameController.text.isNotEmpty) {
                    await SavedCollectionsController.to
                        .createNewCollection(nameController.text)
                        .onError((error, stackTrace) {
                      Get.snackbar("Error", "Failed to create collection");
                    });
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
                    controller: nameController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        labelText: 'Collection name',
                        labelStyle: const TextStyle(fontSize: 14),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ThemeController.to.isDarkTheme.value
                                    ? Colors.white24
                                    : Colors.black26)),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 1,
                        )))),
              ),
            ]),
      ),
    );
  }
}
