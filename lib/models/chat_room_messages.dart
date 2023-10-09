import 'dart:convert';

ChatRoomMessages chatRoomMessagesFromJson(String str) => ChatRoomMessages.fromJson(json.decode(str));

String chatRoomMessagesToJson(ChatRoomMessages data) => json.encode(data.toJson());

class ChatRoomMessages {
  int id;
  List<Map<String,dynamic>> messages;

  ChatRoomMessages({
    required this.id,
    required this.messages,
  });

  factory ChatRoomMessages.fromJson(Map<String, dynamic> json) => ChatRoomMessages(
    id: json["id"],
    messages: List<Map<String,dynamic>>.from(json["messages"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "messages": List<dynamic>.from(messages.map((x) => x)),
  };
}
