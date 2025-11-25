import 'package:chatzz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/error_handler.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';

class NewChatView extends StatefulWidget {
  const NewChatView({super.key});

  @override
  State<NewChatView> createState() => _NewChatViewState();
}

class _NewChatViewState extends State<NewChatView> {
  late Future<List<UserModel>> _usersFuture;
  final AuthService _authService = Get.find();
  final FirestoreService _firestoreService = Get.find();

  @override
  void initState() {
    super.initState();
    _usersFuture = _loadUsers();
  }

  /// Load all users except current user
  Future<List<UserModel>> _loadUsers() async {
    try {
      final allUsers = await _firestoreService.getAllUsers();
      final currentUserId = _authService.currentUser?.uid ?? '';

      // Filter out current user
      return allUsers.where((user) => user.id != currentUserId).toList();
    } catch (e) {
      ErrorHandler.handleFirestoreError(Get.context!, e);
      return [];
    }
  }

  /// Handle user selection and navigate to chat
  /// Checks if conversation exists, creates new one if needed, then navigates
  Future<void> _selectUser(UserModel user) async {
    try {
      final currentUserId = _authService.currentUser?.uid ?? '';

      // Validate current user
      if (currentUserId.isEmpty) {
        throw Exception('User not authenticated');
      }

      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Check if conversation already exists
      final existingConversation = await _firestoreService.findConversation(
        currentUserId,
        user.id,
      );

      // Close loading dialog
      Get.back();

      if (existingConversation != null) {
        // Navigate to existing conversation
        Get.toNamed(
          Routes.CHAT,
          arguments: {'conversationId': existingConversation.id},
        );
      } else {
        // Navigate to chat with new conversation flag
        Get.toNamed(
          Routes.CHAT,
          arguments: {'isNewChat': true, 'otherUserId': user.id},
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      ErrorHandler.handleFirestoreError(Get.context!, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading users',
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return Center(
              child: Text(
                'No users available',
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                onTap: () => _selectUser(user),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.teal[100],
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                title: Text(
                  user.name.isNotEmpty ? user.name : 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  user.email,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
