import 'dart:convert';

SavedCollectionMessages savedCollectionMessagesFromJson(String str) =>
    SavedCollectionMessages.fromJson(json.decode(str));

String savedCollectionMessagesToJson(SavedCollectionMessages data) =>
    json.encode(data.toJson());

class SavedCollectionMessages {
  int id;
  List<Map<String, dynamic>> messages;

  SavedCollectionMessages({
    required this.id,
    required this.messages,
  });

  factory SavedCollectionMessages.fromJson(Map<String, dynamic> json) =>
      SavedCollectionMessages(
        id: json["id"],
        messages:
            List<Map<String, dynamic>>.from(json["messages"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "messages": List<dynamic>.from(messages.map((x) => x)),
      };
}
