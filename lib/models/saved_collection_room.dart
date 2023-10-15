class SavedCollectionRoom {
  final int id;
  final String name;
  final String createdOn;

  SavedCollectionRoom(
      {required this.id, required this.name, required this.createdOn});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'created': createdOn};
  }

  factory SavedCollectionRoom.fromMap(Map<String, dynamic> map) {
    return SavedCollectionRoom(
      id: map['id'] is int ? map['id'] : int.parse(map['id']),
      name: map['name']?.toString() ?? '',
      createdOn: map['created']?.toString() ?? '',
    );
  }
}
