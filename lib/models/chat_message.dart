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
      id: map['id']?.toString() ?? '',
      query: map['query']?.toString() ?? '',
      response: map['response']?.toString() ?? '',
      timestamp: map['timestamp'] is String
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'query': query,
      'response': response,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ChatMessage{id: $id, query: $query, response: $response, timestamp: $timestamp}';
  }
}
