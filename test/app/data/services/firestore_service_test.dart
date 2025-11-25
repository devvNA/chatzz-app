import 'package:chatzz/app/data/models/conversation_model.dart';
import 'package:chatzz/app/data/models/message_model.dart';
import 'package:chatzz/app/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirestoreService - Model Tests', () {
    group('Model Serialization Tests', () {
      test('UserModel serialization round-trip', () {
        // **Feature: chatzz-messaging-app, Property 5: Model serialization round-trip**
        final original = UserModel(
          id: 'user123',
          name: 'John Doe',
          email: 'john@example.com',
          photoUrl: 'https://example.com/photo.jpg',
          createdAt: DateTime(2024, 1, 1, 12, 0, 0),
        );

        final json = original.toJson();
        final deserialized = UserModel.fromJson(json);

        expect(deserialized, equals(original));
      });

      test('MessageModel serialization round-trip', () {
        // **Feature: chatzz-messaging-app, Property 5: Model serialization round-trip**
        final original = MessageModel(
          id: 'msg123',
          conversationId: 'conv123',
          senderId: 'user123',
          text: 'Hello World',
          imageUrl: '',
          timestamp: DateTime(2024, 1, 1, 12, 0, 0),
          status: 'sent',
        );

        final json = original.toJson();
        final deserialized = MessageModel.fromJson(json);

        expect(deserialized, equals(original));
      });

      test('ConversationModel serialization round-trip', () {
        // **Feature: chatzz-messaging-app, Property 5: Model serialization round-trip**
        final original = ConversationModel(
          id: 'conv123',
          participants: ['user1', 'user2'],
          lastMessage: 'Last message text',
          lastMessageTime: DateTime(2024, 1, 1, 12, 0, 0),
        );

        final json = original.toJson();
        final deserialized = ConversationModel.fromJson(json);

        expect(deserialized, equals(original));
      });
    });

    group('copyWith Tests', () {
      test('UserModel copyWith preserves unchanged fields', () {
        // **Feature: chatzz-messaging-app, Property 6: copyWith preserves unchanged fields**
        final original = UserModel(
          id: 'user123',
          name: 'John Doe',
          email: 'john@example.com',
          photoUrl: 'https://example.com/photo.jpg',
        );

        final modified = original.copyWith(name: 'Jane Doe');

        expect(modified.id, equals(original.id));
        expect(modified.email, equals(original.email));
        expect(modified.photoUrl, equals(original.photoUrl));
        expect(modified.name, equals('Jane Doe'));
      });

      test('MessageModel copyWith preserves unchanged fields', () {
        // **Feature: chatzz-messaging-app, Property 6: copyWith preserves unchanged fields**
        final original = MessageModel(
          id: 'msg123',
          conversationId: 'conv123',
          senderId: 'user123',
          text: 'Hello',
          status: 'sending',
        );

        final modified = original.copyWith(status: 'sent');

        expect(modified.id, equals(original.id));
        expect(modified.conversationId, equals(original.conversationId));
        expect(modified.senderId, equals(original.senderId));
        expect(modified.text, equals(original.text));
        expect(modified.status, equals('sent'));
      });

      test('ConversationModel copyWith preserves unchanged fields', () {
        // **Feature: chatzz-messaging-app, Property 6: copyWith preserves unchanged fields**
        final original = ConversationModel(
          id: 'conv123',
          participants: ['user1', 'user2'],
          lastMessage: 'Old message',
        );

        final modified = original.copyWith(lastMessage: 'New message');

        expect(modified.id, equals(original.id));
        expect(modified.participants, equals(original.participants));
        expect(modified.lastMessage, equals('New message'));
      });
    });

    group('Model Default Values Tests', () {
      test('UserModel handles null values with defaults', () {
        final json = {
          'id': 'user123',
          // name, email, photoUrl are missing
        };

        final model = UserModel.fromJson(json);

        expect(model.id, equals('user123'));
        expect(model.name, equals(''));
        expect(model.email, equals(''));
        expect(model.photoUrl, equals(''));
      });

      test('MessageModel handles null values with defaults', () {
        final json = {
          'id': 'msg123',
          'conversationId': 'conv123',
          'senderId': 'user123',
          // text, imageUrl, status are missing
        };

        final model = MessageModel.fromJson(json);

        expect(model.id, equals('msg123'));
        expect(model.text, equals(''));
        expect(model.imageUrl, equals(''));
        expect(model.status, equals('sending'));
      });

      test('ConversationModel handles null values with defaults', () {
        final json = {
          'id': 'conv123',
          // participants, lastMessage are missing
        };

        final model = ConversationModel.fromJson(json);

        expect(model.id, equals('conv123'));
        expect(model.participants, equals([]));
        expect(model.lastMessage, equals(''));
      });
    });

    group('Timestamp Conversion Tests', () {
      test('UserModel converts DateTime to milliseconds and back', () {
        final now = DateTime.now();
        final user = UserModel(id: 'user123', createdAt: now);

        final json = user.toJson();
        final restored = UserModel.fromJson(json);

        // Compare milliseconds since epoch (not exact DateTime due to precision)
        expect(
          restored.createdAt.millisecondsSinceEpoch,
          equals(now.millisecondsSinceEpoch),
        );
      });

      test('MessageModel converts DateTime to milliseconds and back', () {
        final now = DateTime.now();
        final message = MessageModel(
          id: 'msg123',
          conversationId: 'conv123',
          senderId: 'user123',
          timestamp: now,
        );

        final json = message.toJson();
        final restored = MessageModel.fromJson(json);

        expect(
          restored.timestamp.millisecondsSinceEpoch,
          equals(now.millisecondsSinceEpoch),
        );
      });

      test('ConversationModel converts DateTime to milliseconds and back', () {
        final now = DateTime.now();
        final conversation = ConversationModel(
          id: 'conv123',
          lastMessageTime: now,
        );

        final json = conversation.toJson();
        final restored = ConversationModel.fromJson(json);

        expect(
          restored.lastMessageTime.millisecondsSinceEpoch,
          equals(now.millisecondsSinceEpoch),
        );
      });
    });

    group('Model Equality Tests', () {
      test('UserModel equality works correctly', () {
        final user1 = UserModel(
          id: 'user123',
          name: 'John',
          email: 'john@example.com',
        );

        final user2 = UserModel(
          id: 'user123',
          name: 'John',
          email: 'john@example.com',
        );

        expect(user1, equals(user2));
      });

      test('MessageModel equality works correctly', () {
        final msg1 = MessageModel(
          id: 'msg123',
          conversationId: 'conv123',
          senderId: 'user123',
          text: 'Hello',
        );

        final msg2 = MessageModel(
          id: 'msg123',
          conversationId: 'conv123',
          senderId: 'user123',
          text: 'Hello',
        );

        expect(msg1, equals(msg2));
      });

      test('ConversationModel equality works correctly', () {
        final conv1 = ConversationModel(
          id: 'conv123',
          participants: ['user1', 'user2'],
          lastMessage: 'Hi',
        );

        final conv2 = ConversationModel(
          id: 'conv123',
          participants: ['user1', 'user2'],
          lastMessage: 'Hi',
        );

        expect(conv1, equals(conv2));
      });
    });

    group('List Handling Tests', () {
      test('ConversationModel handles participants list correctly', () {
        final participants = ['user1', 'user2', 'user3'];
        final conversation = ConversationModel(
          id: 'conv123',
          participants: participants,
        );

        final json = conversation.toJson();
        final restored = ConversationModel.fromJson(json);

        expect(restored.participants, equals(participants));
        expect(restored.participants.length, equals(3));
      });

      test('ConversationModel handles empty participants list', () {
        final conversation = ConversationModel(id: 'conv123', participants: []);

        final json = conversation.toJson();
        final restored = ConversationModel.fromJson(json);

        expect(restored.participants, equals([]));
        expect(restored.participants.isEmpty, isTrue);
      });
    });

    group('Multiple Round-Trip Tests', () {
      test('UserModel multiple serialization cycles preserve data', () {
        // **Feature: chatzz-messaging-app, Property 5: Model serialization round-trip**
        final original = UserModel(
          id: 'user456',
          name: 'Alice Smith',
          email: 'alice@example.com',
          photoUrl: 'https://example.com/alice.jpg',
        );

        var current = original;
        for (int i = 0; i < 5; i++) {
          final json = current.toJson();
          current = UserModel.fromJson(json);
        }

        expect(current, equals(original));
      });

      test('MessageModel multiple serialization cycles preserve data', () {
        // **Feature: chatzz-messaging-app, Property 5: Model serialization round-trip**
        final original = MessageModel(
          id: 'msg456',
          conversationId: 'conv456',
          senderId: 'user456',
          text: 'Test message',
          status: 'delivered',
        );

        var current = original;
        for (int i = 0; i < 5; i++) {
          final json = current.toJson();
          current = MessageModel.fromJson(json);
        }

        expect(current, equals(original));
      });

      test('ConversationModel multiple serialization cycles preserve data', () {
        // **Feature: chatzz-messaging-app, Property 5: Model serialization round-trip**
        final original = ConversationModel(
          id: 'conv456',
          participants: ['user1', 'user2'],
          lastMessage: 'Test conversation',
        );

        var current = original;
        for (int i = 0; i < 5; i++) {
          final json = current.toJson();
          current = ConversationModel.fromJson(json);
        }

        expect(current, equals(original));
      });
    });

    group('copyWith Chaining Tests', () {
      test('UserModel copyWith can be chained', () {
        // **Feature: chatzz-messaging-app, Property 6: copyWith preserves unchanged fields**
        final original = UserModel(
          id: 'user789',
          name: 'Bob',
          email: 'bob@example.com',
          photoUrl: 'https://example.com/bob.jpg',
        );

        final modified = original
            .copyWith(name: 'Robert')
            .copyWith(email: 'robert@example.com')
            .copyWith(photoUrl: 'https://example.com/robert.jpg');

        expect(modified.id, equals(original.id));
        expect(modified.name, equals('Robert'));
        expect(modified.email, equals('robert@example.com'));
        expect(modified.photoUrl, equals('https://example.com/robert.jpg'));
      });

      test('MessageModel copyWith can be chained', () {
        // **Feature: chatzz-messaging-app, Property 6: copyWith preserves unchanged fields**
        final original = MessageModel(
          id: 'msg789',
          conversationId: 'conv789',
          senderId: 'user789',
          text: 'Original',
          status: 'sending',
        );

        final modified = original
            .copyWith(text: 'Updated')
            .copyWith(status: 'sent')
            .copyWith(status: 'delivered');

        expect(modified.id, equals(original.id));
        expect(modified.conversationId, equals(original.conversationId));
        expect(modified.text, equals('Updated'));
        expect(modified.status, equals('delivered'));
      });
    });
  });
}
