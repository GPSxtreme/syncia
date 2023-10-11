import 'dart:async';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/chat_message.dart';
import '../models/chat_room_data.dart';
import '../models/chat_room_messages.dart';

class DatabaseService {
  static const String dbName = 'syncia.db';
  static const String chatRoomsDataStoreName = 'chat_rooms_data';
  static const String chatRoomsMessagesStoreName = 'chat_rooms_messages';

  final DatabaseFactory _databaseFactory = databaseFactoryIo;
  Database? _database;

  Future<Database> get database async {
    final status = await Permission.storage.status;
    if (status.isDenied || status.isRestricted) {
      await Permission.storage.request();
    }
    return _database ??= await _databaseFactory.openDatabase(
        '${(await getApplicationDocumentsDirectory()).path}/$dbName');
  }

  StoreRef<int, Map<String, dynamic>> _store(String name) =>
      intMapStoreFactory.store(name);

  Future<int> createChatRoom(String name, String modelName) async {
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
    return id;
  }

  Future<void> _modifyMessages(
      int roomId, Function(List<Map<String, dynamic>>) modify) async {
    final db = await database;
    final messageStore = _store(chatRoomsMessagesStoreName);
    final snapshot = await messageStore.findFirst(db,
        finder: Finder(filter: Filter.equals('id', roomId)));

    if (snapshot == null) {
      throw Exception('Chat room not found');
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

      // Determine the start and end indexes for slicing
      int startIndex = max(0, allMessages.length - end - limit);
      int endIndex = allMessages.length - end;

      // Slice the list for pagination.
      final messages = allMessages.sublist(startIndex, endIndex);

      return messages;
    } else {
      throw Exception('Chat room not found');
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
      throw Exception('Chat room not found');
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
}
