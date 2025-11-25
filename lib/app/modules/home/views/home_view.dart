import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatzz/app/data/models/conversation_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_helper.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: context.screenBackgroundColor,
          body: Column(
            children: [
              _buildGradientHeader(context, controller),
              _buildFilterChips(context, controller),
              Expanded(child: _buildConversationList(context, controller)),
            ],
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: Get.height * 0.12, right: 12),
            child: _buildFAB(context, controller),
          ),
        );
      },
    );
  }

  Widget _buildGradientHeader(BuildContext context, HomeController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.gradientStartColor, context.gradientEndColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: const Text(
                'Chatzz',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            _buildSearchBar(context, controller),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, HomeController controller) {
    final isDark = context.isDark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            Icons.search_rounded,
            color: context.textSecondaryColor.withValues(alpha: 0.5),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller.searchController,
              focusNode: controller.searchFocusNode,
              onChanged: controller.onSearchChanged,
              style: TextStyle(fontSize: 16, color: context.textPrimaryColor),
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: context.textSecondaryColor.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          Obx(() {
            if (controller.searchQuery.value.isNotEmpty) {
              return GestureDetector(
                onTap: controller.clearSearch,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Icon(
                    Icons.close_rounded,
                    color: context.textSecondaryColor.withValues(alpha: 0.5),
                    size: 20,
                  ),
                ),
              );
            }
            return GestureDetector(
              onTap: () => _showFilterBottomSheet(context, controller),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Icon(
                  Icons.tune_rounded,
                  color: context.textSecondaryColor.withValues(alpha: 0.5),
                  size: 22,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, HomeController controller) {
    return Obx(() {
      final hasActiveFilter =
          controller.selectedFilter.value != ConversationFilter.all ||
          controller.searchQuery.value.isNotEmpty;

      if (!hasActiveFilter) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        child: Row(
          children: [
            if (controller.selectedFilter.value != ConversationFilter.all)
              _buildActiveFilterChip(
                context: context,
                label: controller.getFilterLabel(
                  controller.selectedFilter.value,
                ),
                onRemove: () => controller.setFilter(ConversationFilter.all),
              ),
            if (controller.searchQuery.value.isNotEmpty) ...[
              if (controller.selectedFilter.value != ConversationFilter.all)
                const SizedBox(width: 8),
              _buildActiveFilterChip(
                context: context,
                label: '"${controller.searchQuery.value}"',
                onRemove: controller.clearSearch,
              ),
            ],
            const Spacer(),
            Obx(
              () => Text(
                '${controller.filteredConversations.length} results',
                style: TextStyle(
                  fontSize: 13,
                  color: context.textSecondaryColor.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildActiveFilterChip({
    required BuildContext context,
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.primaryColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: context.primaryColor,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: 16,
              color: context.primaryColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, HomeController controller) {
    final isDark = context.isDark;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColorsDark.surface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColorsDark.divider : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Filter Conversations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: context.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 20),
            ...ConversationFilter.values.map(
              (filter) => _buildFilterOption(context, controller, filter),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    HomeController controller,
    ConversationFilter filter,
  ) {
    final isDark = context.isDark;

    return Obx(() {
      final isSelected = controller.selectedFilter.value == filter;
      final count = controller.getFilterCount(filter);

      return InkWell(
        onTap: () {
          controller.setFilter(filter);
          Get.back();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? context.primaryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? context.primaryColor.withValues(alpha: 0.3)
                  : (isDark ? AppColorsDark.divider : Colors.grey).withValues(
                      alpha: 0.2,
                    ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _getFilterIcon(filter),
                color: isSelected
                    ? context.primaryColor
                    : context.textSecondaryColor,
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  controller.getFilterLabel(filter),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? context.primaryColor
                        : context.textPrimaryColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.primaryColor.withValues(alpha: 0.2)
                      : (isDark ? AppColorsDark.divider : Colors.grey)
                            .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? context.primaryColor
                        : context.textSecondaryColor,
                  ),
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 12),
                Icon(
                  Icons.check_rounded,
                  color: context.primaryColor,
                  size: 22,
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  IconData _getFilterIcon(ConversationFilter filter) {
    switch (filter) {
      case ConversationFilter.all:
        return Icons.chat_bubble_outline_rounded;
      case ConversationFilter.unread:
        return Icons.mark_chat_unread_outlined;
      case ConversationFilter.recent:
        return Icons.access_time_rounded;
    }
  }

  Widget _buildConversationList(
    BuildContext context,
    HomeController controller,
  ) {
    return Obx(() {
      final conversationsList = controller.filteredConversations;

      if (controller.conversations.isEmpty) {
        return _buildEmptyState(context, controller);
      }

      if (conversationsList.isEmpty) {
        return _buildNoResultsState(context, controller);
      }

      return ListView.separated(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        physics: const BouncingScrollPhysics(),
        itemCount: conversationsList.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          indent: 88,
          endIndent: 20,
          color: context.dividerColor.withValues(alpha: 0.15),
        ),
        itemBuilder: (context, index) {
          final conversation = conversationsList[index];
          return _ConversationTile(
            conversation: conversation,
            controller: controller,
            colorIndex: index,
          );
        },
      );
    });
  }

  Widget _buildNoResultsState(BuildContext context, HomeController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: context.primaryColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter',
            style: TextStyle(
              fontSize: 14,
              color: context.textSecondaryColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              controller.clearSearch();
              controller.setFilter(ConversationFilter.all);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: context.primaryColor),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Clear filters',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, HomeController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 56,
              color: context.primaryColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a new chat to connect with friends',
            style: TextStyle(
              fontSize: 15,
              color: context.textSecondaryColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => controller.navigateToNewChat(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.gradientStartColor,
                    context.gradientEndColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: context.primaryColor.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Start New Chat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context, HomeController controller) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.gradientStartColor, context.gradientEndColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => controller.navigateToNewChat(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.chat_bubble_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  final HomeController controller;
  final int colorIndex;

  const _ConversationTile({
    required this.conversation,
    required this.controller,
    required this.colorIndex,
  });

  static const List<Color> avatarColors = [
    Color(0xFFE91E8C),
    Color(0xFF42A5F5),
    Color(0xFFFF7043),
    Color(0xFF66BB6A),
    Color(0xFFAB47BC),
    Color(0xFFFFCA28),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: controller.getOtherParticipantInfo(conversation),
      builder: (context, snapshot) {
        final otherUserName = snapshot.data?['name'] ?? 'Loading...';
        final otherUserPhoto = snapshot.data?['photoUrl'] as String?;
        final unreadCount = conversation.unreadCount;

        return InkWell(
          onTap: () {
            Get.toNamed(
              Routes.CHAT,
              arguments: {'conversationId': conversation.id},
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                _buildAvatar(context, otherUserName, otherUserPhoto),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _buildHighlightedText(
                              context,
                              otherUserName,
                              controller.searchQuery.value,
                              TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: context.textPrimaryColor,
                              ),
                            ),
                          ),
                          Text(
                            _formatTime(conversation.lastMessageTime),
                            style: TextStyle(
                              fontSize: 13,
                              color: context.textSecondaryColor.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: _buildHighlightedText(
                              context,
                              conversation.lastMessage.isNotEmpty
                                  ? conversation.lastMessage
                                  : 'No messages yet',
                              controller.searchQuery.value,
                              TextStyle(
                                fontSize: 15,
                                color: unreadCount > 0
                                    ? context.textPrimaryColor
                                    : context.textSecondaryColor.withValues(
                                        alpha: 0.7,
                                      ),
                                fontWeight: unreadCount > 0
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          if (unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            _buildUnreadBadge(context, unreadCount),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHighlightedText(
    BuildContext context,
    String text,
    String query,
    TextStyle style, {
    int maxLines = 1,
  }) {
    if (query.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    final endIndex = startIndex + query.length;

    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(text: text.substring(0, startIndex), style: style),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: style.copyWith(
              backgroundColor: context.primaryColor.withValues(alpha: 0.2),
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: text.substring(endIndex), style: style),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String name, String? photoUrl) {
    final color = avatarColors[colorIndex % avatarColors.length];

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2.5),
      ),
      child: photoUrl != null && photoUrl.isNotEmpty
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: photoUrl,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    _buildAvatarPlaceholder(context, name),
                errorWidget: (context, url, error) =>
                    _buildAvatarPlaceholder(context, name),
              ),
            )
          : _buildAvatarPlaceholder(context, name),
    );
  }

  Widget _buildAvatarPlaceholder(BuildContext context, String name) {
    final isDark = context.isDark;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surfaceLight : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColorsDark.textSecondary : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildUnreadBadge(BuildContext context, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$hour12:$minute $period';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
