import 'package:flutter/material.dart';
import 'package:syncia/controllers/saved_collections_controller.dart';
import 'package:syncia/widgets/app_drawer.dart';
import 'package:get/get.dart';
import 'package:syncia/widgets/create_collection_dialog_box.dart';
import 'package:syncia/widgets/saved_collection_tile.dart';

class SavedCollectionsPage extends StatelessWidget {
  const SavedCollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Saved',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        elevation: 0.5,
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            size: 40,
          ),
          onPressed: () => showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return const CreateCollectionDialogBox();
                },
              )),
      body: GetBuilder<SavedCollectionsController>(
        assignId: true,
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Material(
                    shape: const CircleBorder(),
                    color: Theme.of(context).colorScheme.secondary,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.surfaceDim,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    "No saved collections. Create one by clicking the + button.",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.surfaceDim),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
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
