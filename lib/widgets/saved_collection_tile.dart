import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncia/controllers/saved_collections_controller.dart';
import 'package:syncia/models/saved_collection_room.dart';
import 'package:get/get.dart';

import '../route.dart';

class SavedCollectionTile extends StatelessWidget {
  const SavedCollectionTile({super.key, required this.collection});
  final SavedCollectionRoom collection;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        collection.name,
        style: const TextStyle(fontSize: 15),
      ),
      onTap: () {
        // go to text chat page
        Get.toNamed(Routes.savedCollectionPage, arguments: collection.toMap());
      },
      subtitle: Text(
        'Created on : ${DateFormat('d MMMM, h:mm a').format(DateTime.parse(collection.createdOn).toLocal())}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: IconButton(
        onPressed: () async {
          await SavedCollectionsController.to.deleteChatRoom(collection.id);
        },
        icon: const Icon(
          Icons.delete,
          size: 30,
        ),
      ),
    );
  }
}
