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
  /// Note: Sorting is done client-side to avoid requiring a composite index
  Stream<List<ConversationModel>> getConversations(String userId) {
    try {
      if (userId.isEmpty) {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'invalid-argument',
          message: 'User ID cannot be empty',
        );
      }

      return _firestore
          .collection(_conversationsCollection)
          .where('participants', arrayContains: userId)
          .snapshots()
          .map((snapshot) {
            final conversations = snapshot.docs
                .map((doc) => ConversationModel.fromJson(doc.data()))
                .toList();
            // Sort client-side by lastMessageTime descending
            conversations.sort(
              (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
            );
            return conversations;
          });
    } catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        code: 'stream-error',
        message: 'Failed to get conversations stream: ${e.toString()}',
      );
    }
  }

  /// Get messages stream for a conversation
  /// Returns stream of messages ordered by timestamp ascending
  /// Note: Sorting is done client-side to avoid requiring a composite index
  Stream<List<MessageModel>> getMessages(String conversationId) {
    try {
      if (conversationId.isEmpty) {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'invalid-argument',
          message: 'Conversation ID cannot be empty',
        );
      }

      return _firestore
          .collection(_messagesCollection)
          .where('conversationId', isEqualTo: conversationId)
          .snapshots()
          .map((snapshot) {
            final messages = snapshot.docs
                .map((doc) => MessageModel.fromJson(doc.data()))
                .toList();
            // Sort client-side by timestamp ascending
            messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
            return messages;
          });
    } catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        code: 'stream-error',
        message: 'Failed to get messages stream: ${e.toString()}',
      );
    }
  }

  /// Send a message to a conversation
  /// Creates message document and updates conversation metadata
  Future<void> sendMessage(MessageModel message) async {
    try {
      // Validate message
      if (message.id.isEmpty || message.conversationId.isEmpty) {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'invalid-argument',
          message: 'Message ID and conversation ID are required',
        );
      }

      if (message.text.isEmpty) {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'invalid-argument',
          message: 'Message text cannot be empty',
        );
      }

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
      String errorMessage;
      switch (e.code) {
        case 'permission-denied':
          errorMessage = 'You do not have permission to send messages';
          break;
        case 'unavailable':
          errorMessage = 'Service temporarily unavailable. Please try again';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection';
          break;
        default:
          errorMessage = e.message ?? 'Failed to send message';
      }
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: errorMessage,
      );
    } catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        code: 'unknown',
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Create a new conversation
  /// Returns the created conversation ID
  Future<String> createConversation(ConversationModel conversation) async {
    try {
      // Validate conversation
      if (conversation.id.isEmpty) {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'invalid-argument',
          message: 'Conversation ID cannot be empty',
        );
      }

      if (conversation.participants.length < 2) {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'invalid-argument',
          message: 'Conversation must have at least 2 participants',
        );
      }

      await _firestore
          .collection(_conversationsCollection)
          .doc(conversation.id)
          .set(conversation.toJson());

      return conversation.id;
    } on FirebaseException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'permission-denied':
          errorMessage = 'You do not have permission to create conversations';
          break;
        case 'unavailable':
          errorMessage = 'Service temporarily unavailable. Please try again';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection';
          break;
        default:
          errorMessage = e.message ?? 'Failed to create conversation';
      }
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: errorMessage,
      );
    } catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        code: 'unknown',
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get conversation by ID
  Future<ConversationModel?> getConversationById(String conversationId) async {
    try {
      if (conversationId.isEmpty) {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'invalid-argument',
          message: 'Conversation ID cannot be empty',
        );
      }

      final doc = await _firestore
          .collection(_conversationsCollection)
          .doc(conversationId)
          .get();

      if (doc.exists && doc.data() != null) {
        return ConversationModel.fromJson(doc.data()!);
      }

      return null;
    } on FirebaseException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'permission-denied':
          errorMessage = 'You do not have permission to view this conversation';
          break;
        case 'unavailable':
          errorMessage = 'Service temporarily unavailable. Please try again';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection';
          break;
        default:
          errorMessage = e.message ?? 'Failed to get conversation';
      }
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: errorMessage,
      );
    } catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        code: 'unknown',
        message: 'An unexpected error occurred: ${e.toString()}',
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
      // Validate conversation ID
      if (conversationId.isEmpty) {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'invalid-argument',
          message: 'Conversation ID cannot be empty',
        );
      }

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
      String errorMessage;
      switch (e.code) {
        case 'not-found':
          errorMessage = 'Conversation not found';
          break;
        case 'permission-denied':
          errorMessage =
              'You do not have permission to update this conversation';
          break;
        case 'unavailable':
          errorMessage = 'Service temporarily unavailable. Please try again';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection';
          break;
        default:
          errorMessage = e.message ?? 'Failed to update conversation';
      }
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: errorMessage,
      );
    } catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        code: 'unknown',
        message: 'An unexpected error occurred: ${e.toString()}',
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
      String errorMessage;
      switch (e.code) {
        case 'permission-denied':
          errorMessage = 'You do not have permission to view users';
          break;
        case 'unavailable':
          errorMessage = 'Service temporarily unavailable. Please try again';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection';
          break;
        default:
          errorMessage = e.message ?? 'Failed to fetch users';
      }
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: errorMessage,
      );
    } catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        code: 'unknown',
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Check if conversation exists between two users
  Future<ConversationModel?> findConversation(
    String userId1,
    String userId2,
  ) async {
    try {
      // Validate user IDs
      if (userId1.isEmpty || userId2.isEmpty) {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'invalid-argument',
          message: 'User IDs cannot be empty',
        );
      }

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
      String errorMessage;
      switch (e.code) {
        case 'permission-denied':
          errorMessage = 'You do not have permission to search conversations';
          break;
        case 'unavailable':
          errorMessage = 'Service temporarily unavailable. Please try again';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection';
          break;
        default:
          errorMessage = e.message ?? 'Failed to find conversation';
      }
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: errorMessage,
      );
    } catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        code: 'unknown',
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Create or update user document
  Future<void> saveUser(UserModel user) async {
    try {
      // Validate user
      if (user.id.isEmpty) {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'invalid-argument',
          message: 'User ID cannot be empty',
        );
      }

      if (user.email.isEmpty) {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'invalid-argument',
          message: 'User email cannot be empty',
        );
      }

      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .set(user.toJson());
    } on FirebaseException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'permission-denied':
          errorMessage = 'You do not have permission to save user data';
          break;
        case 'unavailable':
          errorMessage = 'Service temporarily unavailable. Please try again';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection';
          break;
        default:
          errorMessage = e.message ?? 'Failed to save user';
      }
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: errorMessage,
      );
    } catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        code: 'unknown',
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get user by ID
  Future<UserModel?> getUser(String userId) async {
    try {
      // Validate user ID
      if (userId.isEmpty) {
        throw FirebaseException(
          plugin: 'firestore',
          code: 'invalid-argument',
          message: 'User ID cannot be empty',
        );
      }

      final doc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }

      return null;
    } on FirebaseException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'permission-denied':
          errorMessage = 'You do not have permission to view user data';
          break;
        case 'unavailable':
          errorMessage = 'Service temporarily unavailable. Please try again';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection';
          break;
        default:
          errorMessage = e.message ?? 'Failed to get user';
      }
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: errorMessage,
      );
    } catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        code: 'unknown',
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }
}
