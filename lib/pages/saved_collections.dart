import 'package:flutter/material.dart';
import 'package:syncia/controllers/saved_collections_controller.dart';
import 'package:syncia/widgets/app_drawer.dart';
import 'package:get/get.dart';
import 'package:syncia/widgets/create_collection_dialog_box.dart';
import 'package:syncia/widgets/saved_collection_tile.dart';
import '../controllers/theme_controller.dart';

class SavedCollectionsPage extends StatelessWidget {
  const SavedCollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Saved'),
        elevation: 0.5,
      ),
      floatingActionButton: FloatingActionButton(
          child: Obx(() => Icon(
                Icons.add,
                color: ThemeController.to.isDarkTheme.value
                    ? Colors.blue
                    : Colors.white,
                size: 40,
              )),
          onPressed: () => showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return const CreateCollectionDialogBox();
                },
              )),
      body: GetBuilder<SavedCollectionsController>(
        assignId: true,
        init: SavedCollectionsController(),
        autoRemove: false,
        builder: (controller) {
          if (controller.collections.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.collections.length,
              itemBuilder: (context, index) {
                final collection = controller.collections[index];
                return SavedCollectionTile(collection: collection);
              },
            );
          } else if (controller.collections.isEmpty && controller.initialized) {
            return const Center(
              child: Text(
                'No saved collections available\nCreate new collection by pressing add icon below',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
