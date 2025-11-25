import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_helper.dart';
import '../../../data/models/message_model.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.screenBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: context.isDark
                ? [AppColorsDark.background, AppColorsDark.surface]
                : [const Color(0xFFE8F5F1), const Color(0xFFF0F9F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildMessageList(context)),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDark ? AppColorsDark.surface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () => controller.goBack(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: context.textPrimaryColor,
                  size: 22,
                ),
              ),
              Obx(() => _buildAvatar(context)),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.otherUser.value?.name ?? 'Chat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: context.accentColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 13,
                              color: context.textSecondaryColor.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _showOptionsMenu(context),
                icon: Icon(
                  Icons.more_horiz_rounded,
                  color: context.textSecondaryColor.withValues(alpha: 0.7),
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final user = controller.otherUser.value;
    final photoUrl = user?.photoUrl;
    final name = user?.name ?? '';

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: context.primaryColor.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: photoUrl != null && photoUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: photoUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    _buildAvatarPlaceholder(context, name),
                errorWidget: (context, url, error) =>
                    _buildAvatarPlaceholder(context, name),
              )
            : _buildAvatarPlaceholder(context, name),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(BuildContext context, String name) {
    return Container(
      color: context.primaryColor.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: context.primaryColor,
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.isDark ? AppColorsDark.surface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.isDark
                    ? AppColorsDark.divider
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            _buildOptionItem(
              context: context,
              icon: Icons.person_outline,
              label: 'View Profile',
              onTap: () => Get.back(),
            ),
            _buildOptionItem(
              context: context,
              icon: Icons.notifications_off_outlined,
              label: 'Mute Notifications',
              onTap: () => Get.back(),
            ),
            _buildOptionItem(
              context: context,
              icon: Icons.block_outlined,
              label: 'Block User',
              onTap: () => Get.back(),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withValues(alpha: 0.1)
              : context.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : context.primaryColor,
          size: 22,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : context.textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: context.primaryColor),
        );
      }

      if (controller.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 48,
                  color: context.primaryColor.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No messages yet',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: context.textSecondaryColor.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Say hi to start the conversation!',
                style: TextStyle(
                  fontSize: 14,
                  color: context.textSecondaryColor.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        reverse: true,
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final message =
              controller.messages[controller.messages.length - 1 - index];
          final isOutgoing = message.senderId == controller.currentUserId;
          final showTime = _shouldShowTime(index);

          return Column(
            crossAxisAlignment: isOutgoing
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (showTime) _buildTimeSeparator(context, message.timestamp),
              _MessageBubble(message: message, isOutgoing: isOutgoing),
            ],
          );
        },
      );
    });
  }

  bool _shouldShowTime(int index) {
    if (index == controller.messages.length - 1) return true;

    final currentMessage =
        controller.messages[controller.messages.length - 1 - index];
    final previousMessage =
        controller.messages[controller.messages.length - 2 - index];

    final diff = currentMessage.timestamp.difference(previousMessage.timestamp);
    return diff.inMinutes > 5;
  }

  Widget _buildTimeSeparator(BuildContext context, DateTime timestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        _formatMessageTime(timestamp),
        style: TextStyle(
          fontSize: 12,
          color: context.textSecondaryColor.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  String _formatMessageTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$hour12:$minute $period';
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: context.isDark ? AppColorsDark.surface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                // TODO: Implement attachment picker
              },
              child: Icon(
                Icons.attach_file_rounded,
                color: context.textSecondaryColor.withValues(alpha: 0.6),
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.isDark
                      ? AppColorsDark.surfaceLight
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: context.isDark
                        ? AppColorsDark.border.withValues(alpha: 0.3)
                        : const Color(0xFFE8E8E8),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: controller.messageTextController,
                  style: TextStyle(
                    color: context.textPrimaryColor,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: context.textSecondaryColor.withValues(alpha: 0.5),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => controller.sendMessage(),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => controller.sendMessage(),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.gradientStartColor,
                      context.gradientEndColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: context.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isOutgoing;

  const _MessageBubble({required this.message, required this.isOutgoing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: isOutgoing
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: isOutgoing
                  ? LinearGradient(
                      colors: [
                        context.gradientStartColor,
                        context.gradientEndColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isOutgoing
                  ? null
                  : (context.isDark
                        ? AppColorsDark.surfaceLight
                        : const Color(0xFFE8E8E8)),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isOutgoing ? 20 : 6),
                bottomRight: Radius.circular(isOutgoing ? 6 : 20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.text,
                  style: TextStyle(
                    fontSize: 16,
                    color: isOutgoing ? Colors.white : context.textPrimaryColor,
                    height: 1.4,
                  ),
                ),
                if (isOutgoing) ...[
                  const SizedBox(height: 4),
                  _buildReadStatus(),
                ],
              ],
            ),
          ),
          if (!isOutgoing)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                _formatTime(message.timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: context.textSecondaryColor.withValues(alpha: 0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReadStatus() {
    final isRead = message.status == 'read';
    final isSent = message.status == 'sent' || message.status == 'read';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isRead)
          Text(
            'Read ',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        Icon(
          isSent ? Icons.done_all_rounded : Icons.done_rounded,
          size: 16,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$hour12:$minute $period';
  }
}
