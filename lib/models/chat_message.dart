class ChatMessage {
  final String id;
  final String query;
  final String response;
  final DateTime timestamp;
  bool read;

  ChatMessage({
    required this.id,
    required this.query,
    required this.response,
    required this.timestamp,
    this.read = false,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      query: map['query'] as String,
      response: map['response'] as String,
      read: map['read'] as bool,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'query': query,
      'response': response,
      'timestamp': timestamp.toIso8601String(),
      'read': read,
    };
  }
  void setRead(bool value) {
    read = value;
  }

  @override
  String toString() {
    return 'ChatMessage{id: $id, query: $query, response: $response, timestamp: $timestamp, read: $read}';
  }
}
