class ChatRoomData {
  final int id;
  final String name;
  final String createdOn;

  ChatRoomData({
    required this.id,
    required this.name,
    required this.createdOn,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdOn': createdOn,
    };
  }

  static ChatRoomData fromMap(Map<String, dynamic> map) {
    return ChatRoomData(
      id: map['id'],
      name: map['name'],
      createdOn: map['createdOn'],
    );
  }
}
