import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/error_handler.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_pages.dart';

class ContactsController extends GetxController {
  final FirestoreService _firestoreService = Get.find();
  final AuthService _authService = Get.find();

  final contacts = <UserModel>[].obs;
  final isLoading = false.obs;
  final currentUser = Rxn<UserModel>();

  // Search state
  final searchQuery = ''.obs;
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  final isSearchActive = false.obs;

  late String _currentUserId;

  // Computed filtered contacts
  List<UserModel> get filteredContacts {
    var result = contacts.toList();

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((user) {
        return user.name.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query);
      }).toList();
    }

    // Sort alphabetically
    result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return result;
  }

  // Group contacts by first letter
  Map<String, List<UserModel>> get groupedContacts {
    final filtered = filteredContacts;
    final Map<String, List<UserModel>> grouped = {};

    for (final contact in filtered) {
      final firstLetter = contact.name.isNotEmpty 
          ? contact.name[0].toUpperCase() 
          : '#';
      
      if (!grouped.containsKey(firstLetter)) {
        grouped[firstLetter] = [];
      }
      grouped[firstLetter]!.add(contact);
    }

    // Sort keys alphabetically
    final sortedKeys = grouped.keys.toList()..sort();
    return {for (var key in sortedKeys) key: grouped[key]!};
  }

  @override
  void onInit() {
    super.onInit();
    _currentUserId = _authService.currentUser?.uid ?? '';
    _loadCurrentUser();
    _loadContacts();

    // Listen to search changes with debounce
    debounce(
      searchQuery,
      (_) => update(),
      time: const Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _firestoreService.getUser(_currentUserId);
      if (user != null) {
        currentUser.value = user;
      }
    } catch (e) {
      if (Get.context != null && Get.context!.mounted) {
        ErrorHandler.handleFirestoreError(Get.context!, e);
      }
    }
  }

  Future<void> _loadContacts() async {
    try {
      isLoading.value = true;
      final allUsers = await _firestoreService.getAllUsers();
      // Filter out current user
      contacts.value = allUsers.where((user) => user.id != _currentUserId).toList();
    } catch (e) {
      if (Get.context != null && Get.context!.mounted) {
        ErrorHandler.handleFirestoreError(Get.context!, e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshContacts() async {
    await _loadContacts();
  }

  // Search methods
  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void toggleSearch() {
    isSearchActive.value = !isSearchActive.value;
    if (!isSearchActive.value) {
      clearSearch();
    } else {
      searchFocusNode.requestFocus();
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    searchController.clear();
    searchFocusNode.unfocus();
    isSearchActive.value = false;
  }

  // Start chat with contact
  Future<void> startChatWith(UserModel contact) async {
    try {
      // Check if conversation already exists
      final existingConversation = await _firestoreService.findConversation(
        _currentUserId,
        contact.id,
      );

      if (existingConversation != null) {
        // Navigate to existing conversation
        Get.toNamed(
          Routes.CHAT,
          arguments: {'conversationId': existingConversation.id},
        );
      } else {
        // Create new conversation
        final conversationId = const Uuid().v4();
        final newConversation = ConversationModel(
          id: conversationId,
          participants: [_currentUserId, contact.id],
          lastMessage: '',
          lastMessageTime: DateTime.now(),
        );

        await _firestoreService.createConversation(newConversation);

        Get.toNamed(
          Routes.CHAT,
          arguments: {'conversationId': conversationId},
        );
      }
    } catch (e) {
      if (Get.context != null && Get.context!.mounted) {
        ErrorHandler.handleFirestoreError(Get.context!, e);
      }
    }
  }

  // View contact profile
  void viewProfile(UserModel contact) {
    Get.toNamed(Routes.PROFILE, arguments: {'userId': contact.id});
  }

  // Show contact options bottom sheet
  void showContactOptions(BuildContext context, UserModel contact) {
    // Will be called from view
  }

  // Get online status (placeholder - would need real-time presence system)
  bool isOnline(UserModel contact) {
    // For demo purposes, randomly return online status based on user id hash
    return contact.id.hashCode % 3 == 0;
  }

  // Get contact initials for avatar
  String getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
