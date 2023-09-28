import 'dart:io';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import '../models/chat_message.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
// Define model classes (e.g., ChatMessage, Bookmark)

class DatabaseService {
  static const String dbName = 'syncia.db';
  static const String chatMessagesStoreName = 'chat_messages';
  static const String bookmarksStoreName = 'bookmarks';
  final DatabaseFactory _databaseFactory = databaseFactoryIo;
  Database? _database;

  Future<Database> get database async {
    final status = await Permission.storage.status;
    if(status.isDenied || status.isRestricted){
      await Permission.storage.request();
    }
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    _database ??= await _databaseFactory.openDatabase('${appDocumentsDir.path}/$dbName');
    return _database!;
  }

  Future<void> saveChatMessage(ChatMessage message) async {
    final store = intMapStoreFactory.store(chatMessagesStoreName);
    await store.add(await database, message.toMap());
  }

  Future<List<ChatMessage>> getChatMessages() async {
    try{
      final store = intMapStoreFactory.store(chatMessagesStoreName);
      final snapshots = await store.find(await database);
      return snapshots.map((snapshot) => ChatMessage.fromMap(snapshot.value)).toList();
    }catch(e){
      throw Exception(e);
    }
  }
}
