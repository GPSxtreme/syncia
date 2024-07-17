import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncia/controllers/saved_collections_controller.dart';
import 'package:syncia/models/saved_collection_room.dart';
import 'package:get/get.dart';

import '../route.dart';
import 'common_widgets.dart';

class SavedCollectionTile extends StatelessWidget {
  const SavedCollectionTile({super.key, required this.collection});
  final SavedCollectionRoom collection;
  _showModalBottomSheet(BuildContext context) => showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () async {
                  bool? response = await CommonWidgets.commonAlertDialog(
                      context,
                      title: 'Delete collection?',
                      body: 'This action is irreversible',
                      agreeLabel: "Yes",
                      denyLabel: "No");
                  if (response == true) {
                    await SavedCollectionsController.to
                        .deleteChatRoom(collection.id);
                  }
                  Get.back();
                },
                leading: const Icon(Icons.delete),
                title: const Text('Delete collection'),
              )
            ],
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        collection.name,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: () {
        // go to text chat page
        Get.toNamed(Routes.savedCollectionPage, arguments: collection.toMap());
      },
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          'Created on: ${DateFormat('h:mm a, d MMM yy').format(DateTime.parse(collection.createdOn).toLocal())}',
          style: const TextStyle(fontSize: 15),
        ),
      ),
      onLongPress: () {
        _showModalBottomSheet(context);
      },
    );
  }
}
