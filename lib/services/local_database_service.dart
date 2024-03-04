import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncia/errors/exception_message.dart';
import 'package:syncia/models/chat_message.dart';
import 'package:syncia/models/chat_room_data.dart';
import 'package:syncia/models/chat_room_messages.dart';
import 'package:syncia/models/image_chat_room_data.dart';
import 'package:syncia/models/image_chat_room_messages.dart';
import 'package:syncia/models/image_room_message.dart';
import 'package:syncia/models/saved_collection_messages.dart';
import 'package:syncia/models/saved_collection_room.dart';

enum ThemeSetting { light, dark, systemDefault }

class DatabaseService {
  static const String dbName = 'syncia.db';
  DatabaseFactory dbFactory = databaseFactoryIo;
  static const String chatRoomsDataStoreName = 'chat_rooms_data';
  static const String chatRoomsMessagesStoreName = 'chat_rooms_messages';
  static const String imageRoomsDataStoreName = 'image_rooms_data';
  static const String imageRoomsMessagesStoreName = 'image_rooms_messages';
  static const String savedCollectionRoomsDataStoreName =
      'saved_collection_rooms';
  static const String savedMessagesDataStoreName = 'saved_messages';

  final DatabaseFactory _databaseFactory = databaseFactoryIo;
  Database? _database;

  Future<Database> get database async {
    Directory root = await getTemporaryDirectory();

    return _database ??= await dbFactory.openDatabase(root.path + dbName);}

  StoreRef<int, Map<String, dynamic>> _store(String name) =>
      intMapStoreFactory.store(name);

  /* Operations on text chat rooms */

  Future<ChatRoomData> createChatRoom(String name, String modelName) async {
    try {
      final dataStore = intMapStoreFactory.store(chatRoomsDataStoreName);
      final messageStore = intMapStoreFactory.store(chatRoomsMessagesStoreName);
      int id = await dataStore.generateIntKey(await database);
      final chatRoom = ChatRoomData(
        id: id,
        name: name,
        modelName: modelName,
        createdOn: DateTime.now().toIso8601String(),
      );
      await dataStore.add(await database, chatRoom.toMap());
      await messageStore.add(
          await database, ChatRoomMessages(id: id, messages: []).toJson());
      return chatRoom;
    } catch (e) {
      throw ExceptionMessage(e.toString());
    }
  }

  Future<void> _modifyMessages(
      int roomId, Function(List<Map<String, dynamic>>) modify) async {
    final db = await database;
    final messageStore = _store(chatRoomsMessagesStoreName);
    final snapshot = await messageStore.findFirst(db,
        finder: Finder(filter: Filter.equals('id', roomId)));

    if (snapshot == null) {
      throw ExceptionMessage('Chat room not found');
    }

    final chatRoom = ChatRoomMessages.fromJson(snapshot.value);
    modify(chatRoom.messages);
    await messageStore.record(snapshot.key).put(db, chatRoom.toJson());
  }

  Future<void> saveChatMessage(int roomId, ChatMessage message) async {
    await _modifyMessages(roomId, (messages) => messages.add(message.toMap()));
  }

  Future<List<ChatMessage>> getChatMessages(int roomId,
      {int end = 0, int limit = 20}) async {
    final db = await database;
    final messageStore = _store(chatRoomsMessagesStoreName);

    final finder = Finder(
      filter: Filter.equals('id', roomId),
    );

    final snapshot = await messageStore.findFirst(db, finder: finder);

    if (snapshot != null) {
      final chatRoom = ChatRoomMessages.fromJson(snapshot.value);
      final allMessages =
          chatRoom.messages.map((e) => ChatMessage.fromMap(e)).toList();

      // Ensure startIndex is not negative
      int startIndex = max(0, allMessages.length - end - limit);
      // Ensure endIndex does not exceed the length of the list and is not negative
      int endIndex = max(0, min(allMessages.length - end, allMessages.length));

      // Slice the list for pagination.
      final messages = allMessages.sublist(startIndex, endIndex);

      return messages;
    } else {
      throw ExceptionMessage('Chat room not found');
    }
  }

  Future<List<ChatRoomData>> getChatRooms() async {
    final snapshots = await _store(chatRoomsDataStoreName).find(await database);
    return snapshots
        .map((snapshot) => ChatRoomData.fromMap(snapshot.value))
        .toList();
  }

  Future<ChatRoomData> getChatRoomById(int id) async {
    final snapshot =
        await _store(chatRoomsDataStoreName).record(id).get(await database);
    if (snapshot == null) {
      throw ExceptionMessage('Chat room not found');
    }
    return ChatRoomData.fromMap(snapshot);
  }

  Future<void> updateChatRoom(ChatRoomData room) async {
    await _store(chatRoomsDataStoreName)
        .record(room.id)
        .update(await database, room.toMap());
  }

  Future<void> deleteChatRoom(int id) async {
    final db = await database;
    final dataStore = _store(chatRoomsDataStoreName);
    final messageStore = _store(chatRoomsMessagesStoreName);

    await Future.wait([
      messageStore.delete(db, finder: Finder(filter: Filter.equals('id', id))),
      dataStore.delete(db, finder: Finder(filter: Filter.equals('id', id)))
    ]);
  }

  Future<void> deleteChatMessage(int roomId, String messageId) async {
    _modifyMessages(roomId,
        (messages) => messages.removeWhere((m) => m['id'] == messageId));
  }

  /* Operations on collection */

  Future<int> createNewCollection(String collectionName) async {
    final collectionsStore =
        intMapStoreFactory.store(savedCollectionRoomsDataStoreName);
    final savedMessagesStore =
        intMapStoreFactory.store(savedMessagesDataStoreName);
    int id = await collectionsStore.generateIntKey(await database);
    final chatRoom = SavedCollectionRoom(
      id: id,
      name: collectionName,
      createdOn: DateTime.now().toIso8601String(),
    );
    await collectionsStore.add(await database, chatRoom.toMap());
    await savedMessagesStore.add(
        await database, SavedCollectionMessages(id: id, messages: []).toJson());
    return id;
  }

  Future<void> deleteCollectionRoom(int id) async {
    final db = await database;
    final store = _store(savedCollectionRoomsDataStoreName);
    await store.delete(db, finder: Finder(filter: Filter.equals('id', id)));
  }

  Future<List<SavedCollectionRoom>> getCollectionRooms() async {
    final db = await database;
    final store = _store(savedCollectionRoomsDataStoreName);
    final snapshots = await store.find(db);
    return snapshots
        .map((snapshot) => SavedCollectionRoom.fromMap(snapshot.value))
        .toList();
  }

  Future<void> _modifyCollectionMessages(
      int collectionId, Function(List<Map<String, dynamic>>) modify) async {
    final db = await database;
    final messageStore = _store(savedMessagesDataStoreName);
    final snapshot = await messageStore.findFirst(db,
        finder: Finder(filter: Filter.equals('id', collectionId)));

    if (snapshot == null) {
      throw ExceptionMessage('Collection not found');
    }

    final collection = SavedCollectionMessages.fromJson(snapshot.value);
    modify(collection.messages);
    await messageStore.record(snapshot.key).put(db, collection.toJson());
  }

  Future<void> bookMarkChatMessage(
      int collectionId, ChatMessage message) async {
    await _modifyCollectionMessages(collectionId, (messages) {
      if (!messages.any((m) => m['id'] == message.id)) {
        messages.add(message.toMap());
      } else {
        throw ExceptionMessage('Already added to the collection');
      }
    });
  }

  Future<void> deleteBookMarkedChatMessage(
      int collectionId, String messageId) async {
    _modifyCollectionMessages(collectionId,
        (messages) => messages.removeWhere((m) => m['id'] == messageId));
  }

  Future<List<ChatMessage>> getSavedChatMessages(int roomId,
      {int end = 0, int limit = 20}) async {
    final db = await database;
    final messageStore = _store(savedMessagesDataStoreName);

    final finder = Finder(
      filter: Filter.equals('id', roomId),
    );

    final snapshot = await messageStore.findFirst(db, finder: finder);

    if (snapshot != null) {
      final savedCollection = SavedCollectionMessages.fromJson(snapshot.value);
      final allMessages =
          savedCollection.messages.map((e) => ChatMessage.fromMap(e)).toList();

      // Ensure startIndex is not negative
      int startIndex = max(0, allMessages.length - end - limit);
      // Ensure endIndex does not exceed the length of the list and is not negative
      int endIndex = max(0, min(allMessages.length - end, allMessages.length));

      // Slice the list for pagination.
      final messages = allMessages.sublist(startIndex, endIndex);

      return messages;
    } else {
      throw ExceptionMessage('Collection not found');
    }
  }

  /* operations on image rooms */

  Future<ImageChatRoomData> createImageChatRoom(String name) async {
    try {
      final dataStore = intMapStoreFactory.store(imageRoomsDataStoreName);
      final messageStore =
          intMapStoreFactory.store(imageRoomsMessagesStoreName);
      int id = await dataStore.generateIntKey(await database);
      final imageChatRoom = ImageChatRoomData(
        id: id,
        name: name,
        createdOn: DateTime.now().toIso8601String(),
      );
      await dataStore.add(await database, imageChatRoom.toJson());
      await messageStore.add(
          await database, ImageChatRoomMessages(id: id, messages: []).toJson());
      return imageChatRoom;
    } catch (e) {
      throw ExceptionMessage(e.toString());
    }
  }

  Future<void> _modifyImageMessages(
      int roomId, Function(List<Map<String, dynamic>>) modify) async {
    final db = await database;
    final messageStore = _store(imageRoomsMessagesStoreName);
    final snapshot = await messageStore.findFirst(db,
        finder: Finder(filter: Filter.equals('id', roomId)));

    if (snapshot == null) {
      throw ExceptionMessage('image chat room not found');
    }

    final imageChatRoom = ImageChatRoomMessages.fromJson(snapshot.value);
    modify(imageChatRoom.messages);
    await messageStore.record(snapshot.key).put(db, imageChatRoom.toJson());
  }

  Future<void> saveImageChatMessage(
      int roomId, ImageRoomMessage message) async {
    await _modifyImageMessages(
        roomId, (messages) => messages.add(message.toMap()));
  }

  Future<List<ImageRoomMessage>> getImageChatMessages(int roomId,
      {int end = 0, int limit = 20}) async {
    final db = await database;
    final messageStore = _store(imageRoomsMessagesStoreName);

    final finder = Finder(
      filter: Filter.equals('id', roomId),
    );

    final snapshot = await messageStore.findFirst(db, finder: finder);

    if (snapshot != null) {
      final chatRoom = ImageChatRoomMessages.fromJson(snapshot.value);
      final allMessages =
          chatRoom.messages.map((e) => ImageRoomMessage.fromMap(e)).toList();

      // Ensure startIndex is not negative
      int startIndex = max(0, allMessages.length - end - limit);
      // Ensure endIndex does not exceed the length of the list and is not negative
      int endIndex = max(0, min(allMessages.length - end, allMessages.length));

      // Slice the list for pagination.
      final messages = allMessages.sublist(startIndex, endIndex);

      return messages;
    } else {
      throw ExceptionMessage('Image chat room not found');
    }
  }

  Future<List<ImageChatRoomData>> getImageChatRooms() async {
    final snapshots =
        await _store(imageRoomsDataStoreName).find(await database);
    return snapshots
        .map((snapshot) => ImageChatRoomData.fromJson(snapshot.value))
        .toList();
  }

  Future<ImageChatRoomData> getImageChatRoomById(int id) async {
    final snapshot =
        await _store(imageRoomsDataStoreName).record(id).get(await database);
    if (snapshot == null) {
      throw ExceptionMessage('Image chat room not found');
    }
    return ImageChatRoomData.fromJson(snapshot);
  }

  Future<void> updateImageChatRoom(ImageChatRoomData room) async {
    await _store(imageRoomsDataStoreName)
        .record(room.id)
        .update(await database, room.toJson());
  }

  Future<void> deleteImageChatRoom(int id) async {
    final db = await database;
    final dataStore = _store(imageRoomsDataStoreName);
    final messageStore = _store(imageRoomsMessagesStoreName);

    await Future.wait([
      messageStore.delete(db, finder: Finder(filter: Filter.equals('id', id))),
      dataStore.delete(db, finder: Finder(filter: Filter.equals('id', id)))
    ]);
  }

  Future<void> deleteImageChatMessage(int roomId, String messageId) async {
    _modifyImageMessages(roomId,
        (messages) => messages.removeWhere((m) => m['id'] == messageId));
  }

  /* settings data */
  Future<void> setThemeSetting(ThemeSetting preset) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('themePreset', preset.name);
    } catch (e) {
      throw ExceptionMessage(e.toString());
    }
  }

  Future<ThemeSetting> getThemeSetting() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? snapshot = prefs.getString('themePreset');
      if (snapshot == null) {
        return ThemeSetting.systemDefault;
      }
      return ThemeSetting.values.firstWhere((e) => e.name == snapshot);
    } catch (e) {
      throw ExceptionMessage(e.toString());
    }
  }
}
