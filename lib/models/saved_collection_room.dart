class SavedCollectionRoom {
  final int id;
  final String name;

  SavedCollectionRoom({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory SavedCollectionRoom.fromMap(Map<String, dynamic> map) {
    return SavedCollectionRoom(
      id: map['id'] is int ? map['id'] : int.parse(map['id']),
      name: map['name']?.toString() ?? '',
    );
  }
}
