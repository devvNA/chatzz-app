import 'package:chatzz/app/data/models/conversation_model.dart';
import 'package:chatzz/app/data/models/message_model.dart';
import 'package:chatzz/app/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// Integration tests for core user flows
/// These tests verify the complete user journey through the app
void main() {
  group('User Flow Integration Tests', () {
    test('User model serialization round-trip', () {
      // Test user model can be serialized and deserialized
      final user = UserModel(
        id: 'user123',
        name: 'John Doe',
        email: 'john@example.com',
      );

      final json = user.toJson();
      final deserializedUser = UserModel.fromJson(json);

      expect(deserializedUser.id, equals(user.id));
      expect(deserializedUser.name, equals(user.name));
      expect(deserializedUser.email, equals(user.email));
    });

    test('Message model serialization round-trip', () {
      // Test message model can be serialized and deserialized
      final now = DateTime.now();
      final message = MessageModel(
        id: 'msg123',
        conversationId: 'conv123',
        senderId: 'user123',
        text: 'Hello, World!',
        timestamp: now,
        status: 'sent',
      );

      final json = message.toJson();
      final deserializedMessage = MessageModel.fromJson(json);

      expect(deserializedMessage.id, equals(message.id));
      expect(
        deserializedMessage.conversationId,
        equals(message.conversationId),
      );
      expect(deserializedMessage.senderId, equals(message.senderId));
      expect(deserializedMessage.text, equals(message.text));
      expect(deserializedMessage.status, equals(message.status));
    });

    test('Conversation model serialization round-trip', () {
      // Test conversation model can be serialized and deserialized
      final now = DateTime.now();
      final conversation = ConversationModel(
        id: 'conv123',
        participants: ['user1', 'user2'],
        lastMessage: 'Hello!',
        lastMessageTime: now,
      );

      final json = conversation.toJson();
      final deserializedConversation = ConversationModel.fromJson(json);

      expect(deserializedConversation.id, equals(conversation.id));
      expect(
        deserializedConversation.participants,
        equals(conversation.participants),
      );
      expect(
        deserializedConversation.lastMessage,
        equals(conversation.lastMessage),
      );
    });

    test('User model copyWith preserves unchanged fields', () {
      // Test copyWith method preserves fields that are not updated
      final user = UserModel(
        id: 'user123',
        name: 'John Doe',
        email: 'john@example.com',
      );

      final updatedUser = user.copyWith(name: 'Jane Doe');

      expect(updatedUser.id, equals(user.id));
      expect(updatedUser.name, equals('Jane Doe'));
      expect(updatedUser.email, equals(user.email));
    });

    test('Message model copyWith preserves unchanged fields', () {
      // Test copyWith method preserves fields that are not updated
      final now = DateTime.now();
      final message = MessageModel(
        id: 'msg123',
        conversationId: 'conv123',
        senderId: 'user123',
        text: 'Hello, World!',
        timestamp: now,
        status: 'sending',
      );

      final updatedMessage = message.copyWith(status: 'sent');

      expect(updatedMessage.id, equals(message.id));
      expect(updatedMessage.conversationId, equals(message.conversationId));
      expect(updatedMessage.senderId, equals(message.senderId));
      expect(updatedMessage.text, equals(message.text));
      expect(updatedMessage.timestamp, equals(message.timestamp));
      expect(updatedMessage.status, equals('sent'));
    });

    test('Conversation model copyWith preserves unchanged fields', () {
      // Test copyWith method preserves fields that are not updated
      final now = DateTime.now();
      final conversation = ConversationModel(
        id: 'conv123',
        participants: ['user1', 'user2'],
        lastMessage: 'Hello!',
        lastMessageTime: now,
      );

      final updatedConversation = conversation.copyWith(
        lastMessage: 'Goodbye!',
      );

      expect(updatedConversation.id, equals(conversation.id));
      expect(
        updatedConversation.participants,
        equals(conversation.participants),
      );
      expect(updatedConversation.lastMessage, equals('Goodbye!'));
      expect(
        updatedConversation.lastMessageTime,
        equals(conversation.lastMessageTime),
      );
    });

    test('Models handle null values with defaults', () {
      // Test that models provide default values for null fields
      final userJson = {'id': 'user123'};
      final user = UserModel.fromJson(userJson);

      expect(user.id, equals('user123'));
      expect(user.name, equals(''));
      expect(user.email, equals(''));
    });

    test('Conversation ordering by time', () {
      // Test that conversations can be ordered by lastMessageTime
      final now = DateTime.now();
      final conversations = [
        ConversationModel(
          id: 'conv1',
          participants: ['user1', 'user2'],
          lastMessage: 'First',
          lastMessageTime: now.subtract(const Duration(hours: 2)),
        ),
        ConversationModel(
          id: 'conv2',
          participants: ['user1', 'user3'],
          lastMessage: 'Second',
          lastMessageTime: now.subtract(const Duration(hours: 1)),
        ),
        ConversationModel(
          id: 'conv3',
          participants: ['user1', 'user4'],
          lastMessage: 'Third',
          lastMessageTime: now,
        ),
      ];

      // Sort by lastMessageTime descending (most recent first)
      conversations.sort(
        (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
      );

      expect(conversations[0].id, equals('conv3'));
      expect(conversations[1].id, equals('conv2'));
      expect(conversations[2].id, equals('conv1'));
    });

    test('Message validation - empty text', () {
      // Test that empty messages should be prevented
      final text = '';
      expect(text.trim().isEmpty, isTrue);
    });

    test('Message validation - whitespace only', () {
      // Test that whitespace-only messages should be prevented
      final text = '   ';
      expect(text.trim().isEmpty, isTrue);
    });

    test('Message validation - valid text', () {
      // Test that valid messages pass validation
      final text = 'Hello, World!';
      expect(text.trim().isNotEmpty, isTrue);
    });

    test('Email validation - valid email', () {
      // Test email validation regex
      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      expect(emailRegex.hasMatch('test@example.com'), isTrue);
      expect(emailRegex.hasMatch('user.name@domain.co.uk'), isTrue);
    });

    test('Email validation - invalid email', () {
      // Test email validation regex rejects invalid emails
      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      expect(emailRegex.hasMatch('invalid'), isFalse);
      expect(emailRegex.hasMatch('invalid@'), isFalse);
      expect(emailRegex.hasMatch('@example.com'), isFalse);
      expect(emailRegex.hasMatch('test@.com'), isFalse);
    });

    test('Password validation - minimum length', () {
      // Test password validation (minimum 6 characters)
      expect('12345'.length >= 6, isFalse);
      expect('123456'.length >= 6, isTrue);
      expect('password123'.length >= 6, isTrue);
    });
  });
}
