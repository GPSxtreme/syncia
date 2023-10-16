// To parse this JSON data, do
//
//     final imageChatRoomData = imageChatRoomDataFromJson(jsonString);

import 'dart:convert';

ImageChatRoomData imageChatRoomDataFromJson(String str) =>
    ImageChatRoomData.fromJson(json.decode(str));

String imageChatRoomDataToJson(ImageChatRoomData data) =>
    json.encode(data.toJson());

class ImageChatRoomData {
  int id;
  String name;
  String createdOn;

  ImageChatRoomData({
    required this.id,
    required this.name,
    required this.createdOn,
  });

  factory ImageChatRoomData.fromJson(Map<String, dynamic> json) =>
      ImageChatRoomData(
        id: json["id"],
        name: json["name"],
        createdOn: json["createdOn"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdOn": createdOn,
      };
}
