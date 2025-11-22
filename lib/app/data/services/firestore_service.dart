import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  static const String _usersCollection = 'users';
  static const String _conversationsCollection = 'conversations';
  static const String _messagesCollection = 'messages';

  /// Get conversations stream for a user
  /// Returns stream of conversations ordered by lastMessageTime descending
  Stream<List<ConversationModel>> getConversations(String userId) {
    return _firestore
        .collection(_conversationsCollection)
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ConversationModel.fromJson(doc.data()))
              .toList();
        });
  }

  /// Get messages stream for a conversation
  /// Returns stream of messages ordered by timestamp ascending
  Stream<List<MessageModel>> getMessages(String conversationId) {
    return _firestore
        .collection(_messagesCollection)
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MessageModel.fromJson(doc.data()))
              .toList();
        });
  }

  /// Send a message to a conversation
  /// Creates message document and updates conversation metadata
  Future<void> sendMessage(MessageModel message) async {
    try {
      // Add message to messages collection
      await _firestore
          .collection(_messagesCollection)
          .doc(message.id)
          .set(message.toJson());

      // Update conversation with last message info
      await updateConversation(
        message.conversationId,
        lastMessage: message.text,
        lastMessageTime: message.timestamp,
      );
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: e.message ?? 'Failed to send message',
      );
    }
  }

  /// Create a new conversation
  /// Returns the created conversation ID
  Future<String> createConversation(ConversationModel conversation) async {
    try {
      await _firestore
          .collection(_conversationsCollection)
          .doc(conversation.id)
          .set(conversation.toJson());

      return conversation.id;
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: e.message ?? 'Failed to create conversation',
      );
    }
  }

  /// Update conversation metadata
  /// Updates lastMessage and lastMessageTime fields
  Future<void> updateConversation(
    String conversationId, {
    String? lastMessage,
    DateTime? lastMessageTime,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (lastMessage != null) {
        updates['lastMessage'] = lastMessage;
      }

      if (lastMessageTime != null) {
        updates['lastMessageTime'] = lastMessageTime.millisecondsSinceEpoch;
      }

      if (updates.isNotEmpty) {
        await _firestore
            .collection(_conversationsCollection)
            .doc(conversationId)
            .update(updates);
      }
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: e.message ?? 'Failed to update conversation',
      );
    }
  }

  /// Get all users (for new conversation selection)
  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection(_usersCollection).get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: e.message ?? 'Failed to fetch users',
      );
    }
  }

  /// Check if conversation exists between two users
  Future<ConversationModel?> findConversation(
    String userId1,
    String userId2,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_conversationsCollection)
          .where('participants', arrayContains: userId1)
          .get();

      for (var doc in snapshot.docs) {
        final conversation = ConversationModel.fromJson(doc.data());
        if (conversation.participants.contains(userId2)) {
          return conversation;
        }
      }

      return null;
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: e.message ?? 'Failed to find conversation',
      );
    }
  }

  /// Create or update user document
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .set(user.toJson());
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: e.message ?? 'Failed to save user',
      );
    }
  }

  /// Get user by ID
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }

      return null;
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: e.message ?? 'Failed to get user',
      );
    }
  }
}
