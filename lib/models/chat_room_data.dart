class ChatRoomData {
  final int id;
  final String name;
  final String createdOn;
  final String modelName;
  ChatRoomData({
    required this.id,
    required this.name,
    required this.createdOn,
    required this.modelName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdOn': createdOn,
      'modelName': modelName,
    };
  }

  static ChatRoomData fromMap(Map<String, dynamic> map) {
    return ChatRoomData(
      id: map['id'],
      name: map['name'],
      createdOn: map['createdOn'],
      modelName: map['modelName'],
    );
  }
}
