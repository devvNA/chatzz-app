class ConversationModel {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;

  ConversationModel({
    required this.id,
    List<String>? participants,
    this.lastMessage = '',
    DateTime? lastMessageTime,
  }) : participants = participants ?? [],
       lastMessageTime = lastMessageTime ?? DateTime.now();

  /// Convert model to JSON for Firestore
  Map<String, dynamic> toJson() => {
    'id': id,
    'participants': participants,
    'lastMessage': lastMessage,
    'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
  };

  /// Create model from Firestore JSON
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      participants: json['participants'] != null
          ? List<String>.from(json['participants'] as List)
          : [],
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastMessageTime'] as int)
          : DateTime.now(),
    );
  }

  /// Create a copy with modified fields
  ConversationModel copyWith({
    String? id,
    List<String>? participants,
    String? lastMessage,
    DateTime? lastMessageTime,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConversationModel &&
        other.id == id &&
        _listEquals(other.participants, participants) &&
        other.lastMessage == lastMessage &&
        other.lastMessageTime.millisecondsSinceEpoch ==
            lastMessageTime.millisecondsSinceEpoch;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        participants.hashCode ^
        lastMessage.hashCode ^
        lastMessageTime.hashCode;
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
