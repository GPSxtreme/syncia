class ImageRoomMessage {
  final String id;
  final String query;
  final List<String> imageLinks;
  final DateTime timestamp;

  ImageRoomMessage({
    required this.id,
    required this.query,
    required this.imageLinks,
    required this.timestamp,
  });

  factory ImageRoomMessage.fromMap(Map<String, dynamic> map) {
    return ImageRoomMessage(
      id: map['id']?.toString() ?? '',
      query: map['query']?.toString() ?? '',
      imageLinks: map['imageLinks'].cast<String>(),
      timestamp: map['timestamp'] is String
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'query': query,
      'imageLinks': imageLinks,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ImageRoomMessage{id: $id, query: $query, response: $imageLinks, timestamp: $timestamp}';
  }
}
