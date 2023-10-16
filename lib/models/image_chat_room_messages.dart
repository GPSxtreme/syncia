import 'dart:convert';

ImageChatRoomMessages imageChatRoomMessagesFromJson(String str) =>
    ImageChatRoomMessages.fromJson(json.decode(str));

String imageChatRoomMessagesToJson(ImageChatRoomMessages data) =>
    json.encode(data.toJson());

class ImageChatRoomMessages {
  int id;
  List<Map<String, dynamic>> messages;

  ImageChatRoomMessages({
    required this.id,
    required this.messages,
  });

  factory ImageChatRoomMessages.fromJson(Map<String, dynamic> json) =>
      ImageChatRoomMessages(
        id: json["id"],
        messages:
            List<Map<String, dynamic>>.from(json["messages"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "messages": List<dynamic>.from(messages.map((x) => x)),
      };
}
