import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/error_handler.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';

class ChatController extends GetxController {
  final FirestoreService _firestoreService = Get.find();
  final AuthService _authService = Get.find();

  final messages = <MessageModel>[].obs;
  final isLoading = false.obs;
  final otherUser = Rxn<UserModel>();
  final conversation = Rxn<ConversationModel>();

  final TextEditingController messageTextController = TextEditingController();

  late String _currentUserId;
  late String _conversationId;
  bool _isNewChat = false;
  late String _otherUserId;
  StreamSubscription<List<MessageModel>>? _messagesSubscription;

  @override
  void onInit() {
    super.onInit();
    _currentUserId = _authService.currentUser?.uid ?? '';

    // Get arguments from navigation
    final args = Get.arguments as Map<String, dynamic>?;
    _isNewChat = args?['isNewChat'] ?? false;
    _conversationId = args?['conversationId'] ?? '';
    _otherUserId = args?['otherUserId'] ?? '';

    if (_isNewChat && _otherUserId.isNotEmpty) {
      _initializeNewChat();
    } else if (_conversationId.isNotEmpty) {
      _loadConversation();
    }
  }

  @override
  void onClose() {
    _messagesSubscription?.cancel();
    messageTextController.dispose();
    super.onClose();
  }

  /// Get current user ID
  String get currentUserId => _currentUserId;

  /// Initialize new chat with selected user
  Future<void> _initializeNewChat() async {
    try {
      isLoading.value = true;

      // Load other user data
      final user = await _firestoreService.getUser(_otherUserId);
      if (user != null) {
        otherUser.value = user;
      } else {
        throw Exception('User not found');
      }

      // Check if conversation already exists
      final existingConversation = await _firestoreService.findConversation(
        _currentUserId,
        _otherUserId,
      );

      if (existingConversation != null) {
        // Use existing conversation
        _conversationId = existingConversation.id;
        conversation.value = existingConversation;
        _loadMessages();
      } else {
        // Create new conversation
        final newConversationId = const Uuid().v4();
        final newConversation = ConversationModel(
          id: newConversationId,
          participants: [_currentUserId, _otherUserId],
          lastMessage: '',
          lastMessageTime: DateTime.now(),
        );

        await _firestoreService.createConversation(newConversation);
        _conversationId = newConversationId;
        conversation.value = newConversation;
      }
    } catch (e) {
      ErrorHandler.handleFirestoreError(Get.context!, e);
      Get.back(); // Return to previous screen on error
    } finally {
      isLoading.value = false;
    }
  }

  /// Load conversation and messages
  Future<void> _loadConversation() async {
    try {
      isLoading.value = true;

      // Load other user info from conversation
      await _loadOtherUserFromConversation();

      _loadMessages();
    } catch (e) {
      if (Get.context != null && Get.context!.mounted) {
        ErrorHandler.handleFirestoreError(Get.context!, e);
      }
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  /// Load other user info from conversation participants
  Future<void> _loadOtherUserFromConversation() async {
    // First, get the conversation to find the other user
    final convSnapshot = await _firestoreService.getConversationById(
      _conversationId,
    );

    if (convSnapshot != null) {
      conversation.value = convSnapshot;

      // Find other user ID from participants
      final otherUserId = convSnapshot.participants.firstWhere(
        (id) => id != _currentUserId,
        orElse: () => '',
      );

      if (otherUserId.isNotEmpty) {
        _otherUserId = otherUserId;
        final user = await _firestoreService.getUser(otherUserId);
        if (user != null) {
          otherUser.value = user;
        }
      }
    }
  }

  /// Load messages stream
  void _loadMessages() {
    try {
      _messagesSubscription = _firestoreService
          .getMessages(_conversationId)
          .listen(
            (messageList) {
              messages.value = messageList;
            },
            onError: (error) {
              ErrorHandler.handleFirestoreError(Get.context!, error);
            },
          );
    } catch (e) {
      ErrorHandler.handleFirestoreError(Get.context!, e);
    }
  }

  /// Send message
  Future<void> sendMessage() async {
    final text = messageTextController.text.trim();

    // Validate message (Requirement 3.2)
    final messageError = Validator.required(text);
    if (messageError != null) {
      ErrorHandler.showWarningSnackbar(Get.context!, messageError);
      return;
    }

    try {
      // Create Message Model with UUID (Requirement 3.2)
      final message = MessageModel(
        id: const Uuid().v4(),
        conversationId: _conversationId,
        senderId: _currentUserId,
        text: text,
        timestamp: DateTime.now(),
        status: 'sending',
      );

      // Clear input immediately for better UX
      messageTextController.clear();

      // Add to Firestore and update conversation metadata (Requirements 3.2, 3.3)
      await _firestoreService.sendMessage(message);
    } catch (e) {
      ErrorHandler.handleFirestoreError(Get.context!, e);

      // Restore message text on failure
      messageTextController.text = text;
    }
  }

  /// Go back to home
  void goBack() {
    Get.back();
  }
}
