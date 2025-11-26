import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/error_handler.dart';
import '../../../core/widgets/snackbar_extension.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController with GetSingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = Get.find();
  final AuthService _authService = Get.find();

  final user = Rxn<UserModel>();
  final isLoading = true.obs;
  final isCurrentUser = false.obs;
  
  // Animation controller for staggered animations
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  late String _currentUserId;
  String? _targetUserId;

  @override
  void onInit() {
    super.onInit();
    _currentUserId = _authService.currentUser?.uid ?? '';
    
    // Setup animations
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    
    // Get user ID from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    _targetUserId = args?['userId'] as String?;
    
    if (_targetUserId != null) {
      isCurrentUser.value = _targetUserId == _currentUserId;
      _loadUserProfile();
    } else {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  Future<void> _loadUserProfile() async {
    try {
      isLoading.value = true;
      final loadedUser = await _firestoreService.getUser(_targetUserId!);
      if (loadedUser != null) {
        user.value = loadedUser;
        // Start animation after data loads
        animationController.forward();
      }
    } catch (e) {
      if (Get.context != null && Get.context!.mounted) {
        ErrorHandler.handleFirestoreError(Get.context!, e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void goBack() {
    Get.back();
  }

  // Start chat with this user
  Future<void> startChat() async {
    if (user.value == null || isCurrentUser.value) return;

    try {
      // Check if conversation already exists
      final existingConversation = await _firestoreService.findConversation(
        _currentUserId,
        user.value!.id,
      );

      if (existingConversation != null) {
        Get.offNamed(
          Routes.CHAT,
          arguments: {'conversationId': existingConversation.id},
        );
      } else {
        // Create new conversation
        final conversationId = const Uuid().v4();
        final newConversation = ConversationModel(
          id: conversationId,
          participants: [_currentUserId, user.value!.id],
          lastMessage: '',
          lastMessageTime: DateTime.now(),
        );

        await _firestoreService.createConversation(newConversation);

        Get.offNamed(
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

  // Get online status (placeholder)
  bool get isOnline {
    if (user.value == null) return false;
    return user.value!.id.hashCode % 3 == 0;
  }

  // Get member since formatted
  String get memberSince {
    if (user.value == null) return '';
    final date = user.value!.createdAt;
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  // Get initials for avatar
  String get initials {
    if (user.value == null || user.value!.name.isEmpty) return '?';
    final parts = user.value!.name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return user.value!.name[0].toUpperCase();
  }

  // Show block confirmation
  void showBlockDialog(BuildContext context) {
    // Will be called from view
  }

  // Show report dialog
  void showReportDialog(BuildContext context) {
    // Will be called from view  
  }

  // Block user action
  void blockUser() {
    if (Get.context != null && Get.context!.mounted) {
      Get.context!.showInfoSnackBar(message: 'User blocked');
    }
    Get.back();
  }

  // Report user action
  void reportUser(String reason) {
    if (Get.context != null && Get.context!.mounted) {
      Get.context!.showInfoSnackBar(message: 'Report submitted');
    }
  }
}
