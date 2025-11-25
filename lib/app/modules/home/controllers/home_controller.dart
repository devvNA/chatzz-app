import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/error_handler.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_pages.dart';

enum ConversationFilter { all, unread, recent }

class HomeController extends GetxController {
  final FirestoreService _firestoreService = Get.find();
  final AuthService _authService = Get.find();

  final conversations = <ConversationModel>[].obs;
  final isLoading = false.obs;
  final currentUser = Rxn<UserModel>();

  // Search and filter state
  final searchQuery = ''.obs;
  final selectedFilter = ConversationFilter.all.obs;
  final isSearchActive = false.obs;
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  late String _currentUserId;

  final Map<String, Map<String, dynamic>> _userInfoCache = {};

  // Computed filtered conversations
  List<ConversationModel> get filteredConversations {
    var result = conversations.toList();

    // Apply filter
    switch (selectedFilter.value) {
      case ConversationFilter.unread:
        result = result.where((c) => c.unreadCount > 0).toList();
        break;
      case ConversationFilter.recent:
        final now = DateTime.now();
        final oneDayAgo = now.subtract(const Duration(days: 1));
        result = result.where((c) => c.lastMessageTime.isAfter(oneDayAgo)).toList();
        break;
      case ConversationFilter.all:
        break;
    }

    // Apply search if query exists
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((conversation) {
        // Search in cached user names
        final otherUserId = conversation.participants.firstWhere(
          (id) => id != _currentUserId,
          orElse: () => '',
        );
        final cachedInfo = _userInfoCache[otherUserId];
        final userName = (cachedInfo?['name'] as String?)?.toLowerCase() ?? '';
        
        // Search in user name and last message
        return userName.contains(query) ||
            conversation.lastMessage.toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  @override
  void onInit() {
    super.onInit();
    _currentUserId = _authService.currentUser?.uid ?? '';
    _loadCurrentUser();
    _loadConversations();

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

  void _loadConversations() {
    try {
      _firestoreService.getConversations(_currentUserId).listen(
        (conversationList) {
          conversations.value = conversationList;
          // Pre-cache user info for search
          _preCacheUserInfo(conversationList);
        },
        onError: (error) {
          if (Get.context != null && Get.context!.mounted) {
            ErrorHandler.handleFirestoreError(Get.context!, error);
          }
        },
      );
    } catch (e) {
      if (Get.context != null && Get.context!.mounted) {
        ErrorHandler.handleFirestoreError(Get.context!, e);
      }
    }
  }

  // Pre-cache user info for faster search
  Future<void> _preCacheUserInfo(List<ConversationModel> convList) async {
    for (final conv in convList) {
      await getOtherParticipantInfo(conv);
    }
  }

  Future<Map<String, dynamic>> getOtherParticipantInfo(
    ConversationModel conversation,
  ) async {
    try {
      final otherUserId = conversation.participants.firstWhere(
        (id) => id != _currentUserId,
        orElse: () => '',
      );

      if (otherUserId.isEmpty) {
        return {'name': 'Unknown', 'photoUrl': null};
      }

      if (_userInfoCache.containsKey(otherUserId)) {
        return _userInfoCache[otherUserId]!;
      }

      final user = await _firestoreService.getUser(otherUserId);
      final info = {
        'name': user?.name ?? 'Unknown',
        'photoUrl': user?.photoUrl,
      };

      _userInfoCache[otherUserId] = info;

      return info;
    } catch (e) {
      return {'name': 'Unknown', 'photoUrl': null};
    }
  }

  Future<String> getOtherParticipantName(ConversationModel conversation) async {
    final info = await getOtherParticipantInfo(conversation);
    return info['name'] as String;
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

  // Filter methods
  void setFilter(ConversationFilter filter) {
    selectedFilter.value = filter;
    update();
  }

  String getFilterLabel(ConversationFilter filter) {
    switch (filter) {
      case ConversationFilter.all:
        return 'All Chats';
      case ConversationFilter.unread:
        return 'Unread';
      case ConversationFilter.recent:
        return 'Recent (24h)';
    }
  }

  int getFilterCount(ConversationFilter filter) {
    switch (filter) {
      case ConversationFilter.all:
        return conversations.length;
      case ConversationFilter.unread:
        return conversations.where((c) => c.unreadCount > 0).length;
      case ConversationFilter.recent:
        final now = DateTime.now();
        final oneDayAgo = now.subtract(const Duration(days: 1));
        return conversations.where((c) => c.lastMessageTime.isAfter(oneDayAgo)).length;
    }
  }

  void navigateToNewChat() {
    Get.toNamed(Routes.NEW_CHAT);
  }
}
