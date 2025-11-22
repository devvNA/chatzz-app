class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final String imageUrl;
  final DateTime timestamp;
  final String status;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.text = '',
    this.imageUrl = '',
    DateTime? timestamp,
    this.status = 'sending',
  }) : timestamp = timestamp ?? DateTime.now();

  /// Convert model to JSON for Firestore
  Map<String, dynamic> toJson() => {
    'id': id,
    'conversationId': conversationId,
    'senderId': senderId,
    'text': text,
    'imageUrl': imageUrl,
    'timestamp': timestamp.millisecondsSinceEpoch,
    'status': status,
  };

  /// Create model from Firestore JSON
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      senderId: json['senderId'] ?? '',
      text: json['text'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int)
          : DateTime.now(),
      status: json['status'] ?? 'sending',
    );
  }

  /// Create a copy with modified fields
  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? text,
    String? imageUrl,
    DateTime? timestamp,
    String? status,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageModel &&
        other.id == id &&
        other.conversationId == conversationId &&
        other.senderId == senderId &&
        other.text == text &&
        other.imageUrl == imageUrl &&
        other.timestamp.millisecondsSinceEpoch ==
            timestamp.millisecondsSinceEpoch &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        conversationId.hashCode ^
        senderId.hashCode ^
        text.hashCode ^
        imageUrl.hashCode ^
        timestamp.hashCode ^
        status.hashCode;
  }
}
