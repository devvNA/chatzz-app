import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_helper.dart';
import '../../../data/models/user_model.dart';
import '../controllers/contacts_controller.dart';

class ContactsView extends GetView<ContactsController> {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactsController>(
      init: ContactsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: context.screenBackgroundColor,
          body: Column(
            children: [
              _buildHeader(context, controller),
              Expanded(child: _buildContactsList(context, controller)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ContactsController controller) {
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
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Contacts',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.refreshContacts(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => _showAddContactSheet(context, controller),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.person_add_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildSearchBar(context, controller),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ContactsController controller) {
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
              style: TextStyle(
                fontSize: 16,
                color: context.textPrimaryColor,
              ),
              decoration: InputDecoration(
                hintText: 'Search contacts...',
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
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildContactsList(BuildContext context, ContactsController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: context.primaryColor),
        );
      }

      if (controller.contacts.isEmpty) {
        return _buildEmptyState(context, controller);
      }

      final grouped = controller.groupedContacts;

      if (grouped.isEmpty) {
        return _buildNoResultsState(context, controller);
      }

      return RefreshIndicator(
        onRefresh: controller.refreshContacts,
        color: context.primaryColor,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 100),
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          itemCount: grouped.length,
          itemBuilder: (context, index) {
            final letter = grouped.keys.elementAt(index);
            final contactsForLetter = grouped[letter]!;

            return _buildLetterGroup(context, controller, letter, contactsForLetter);
          },
        ),
      );
    });
  }

  Widget _buildLetterGroup(
    BuildContext context,
    ContactsController controller,
    String letter,
    List<UserModel> contacts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Letter header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 1,
                  color: context.dividerColor.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
        // Contacts for this letter
        ...contacts.map((contact) => _ContactTile(
              contact: contact,
              controller: controller,
            )),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, ContactsController controller) {
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
              Icons.people_outline_rounded,
              size: 56,
              color: context.primaryColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No contacts yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your contacts will appear here',
            style: TextStyle(
              fontSize: 15,
              color: context.textSecondaryColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => _showAddContactSheet(context, controller),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [context.gradientStartColor, context.gradientEndColor],
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
                  Icon(Icons.person_add_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Add Contact',
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

  Widget _buildNoResultsState(BuildContext context, ContactsController controller) {
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
            'No contacts found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              fontSize: 14,
              color: context.textSecondaryColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: controller.clearSearch,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: context.primaryColor),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Clear search',
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

  void _showAddContactSheet(BuildContext context, ContactsController controller) {
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
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColorsDark.divider : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Add Contact',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: context.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 24),
            _buildAddOption(
              context: context,
              icon: Icons.qr_code_scanner_rounded,
              label: 'Scan QR Code',
              subtitle: 'Scan a QR code to add contact',
              onTap: () {
                Get.back();
                _showComingSoon(context);
              },
            ),
            const SizedBox(height: 12),
            _buildAddOption(
              context: context,
              icon: Icons.contact_phone_rounded,
              label: 'From Phone Contacts',
              subtitle: 'Import from your phone contacts',
              onTap: () {
                Get.back();
                _showComingSoon(context);
              },
            ),
            const SizedBox(height: 12),
            _buildAddOption(
              context: context,
              icon: Icons.link_rounded,
              label: 'Share Invite Link',
              subtitle: 'Invite friends via link',
              onTap: () {
                Get.back();
                _showComingSoon(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColorsDark.surfaceLight.withValues(alpha: 0.5)
              : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.dividerColor.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: context.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.textSecondaryColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.textSecondaryColor.withValues(alpha: 0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Coming soon!'),
        backgroundColor: context.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final UserModel contact;
  final ContactsController controller;

  const _ContactTile({
    required this.contact,
    required this.controller,
  });

  static const List<Color> avatarColors = [
    Color(0xFFE91E8C),
    Color(0xFF42A5F5),
    Color(0xFFFF7043),
    Color(0xFF66BB6A),
    Color(0xFFAB47BC),
    Color(0xFFFFCA28),
    Color(0xFF26C6DA),
    Color(0xFFEC407A),
  ];

  @override
  Widget build(BuildContext context) {
    final isOnline = controller.isOnline(contact);
    final colorIndex = contact.id.hashCode % avatarColors.length;

    return InkWell(
      onTap: () => controller.startChatWith(contact),
      onLongPress: () => _showContactOptions(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            _buildAvatar(context, isOnline, colorIndex),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name.isNotEmpty ? contact.name : 'Unknown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (isOnline) ...[
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
                            color: context.accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ] else
                        Text(
                          contact.email,
                          style: TextStyle(
                            fontSize: 13,
                            color: context.textSecondaryColor.withValues(alpha: 0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Quick actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildQuickAction(
                  context: context,
                  icon: Icons.chat_bubble_outline_rounded,
                  onTap: () => controller.startChatWith(contact),
                ),
                const SizedBox(width: 8),
                _buildQuickAction(
                  context: context,
                  icon: Icons.more_vert_rounded,
                  onTap: () => _showContactOptions(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, bool isOnline, int colorIndex) {
    final color = avatarColors[colorIndex];
    final photoUrl = contact.photoUrl;
    final name = contact.name;
    final isDark = context.isDark;

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: photoUrl.isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: photoUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildAvatarPlaceholder(context, name, color),
                    errorWidget: (context, url, error) => _buildAvatarPlaceholder(context, name, color),
                  ),
                )
              : _buildAvatarPlaceholder(context, name, color),
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: context.accentColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColorsDark.background : Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatarPlaceholder(BuildContext context, String name, Color accentColor) {
    final isDark = context.isDark;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surfaceLight : accentColor.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          controller.getInitials(name),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColorsDark.textSecondary : accentColor,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: context.primaryColor,
          size: 20,
        ),
      ),
    );
  }

  void _showContactOptions(BuildContext context) {
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
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColorsDark.divider : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // Contact info header
            Row(
              children: [
                _buildAvatar(context, controller.isOnline(contact), 
                    contact.id.hashCode % avatarColors.length),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        contact.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Options
            _buildOptionItem(
              context: context,
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Send Message',
              onTap: () {
                Get.back();
                controller.startChatWith(contact);
              },
            ),
            _buildOptionItem(
              context: context,
              icon: Icons.person_outline_rounded,
              label: 'View Profile',
              onTap: () {
                Get.back();
                controller.viewProfile(contact);
              },
            ),
            _buildOptionItem(
              context: context,
              icon: Icons.notifications_off_outlined,
              label: 'Mute Notifications',
              onTap: () {
                Get.back();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Coming soon!'),
                    backgroundColor: context.primaryColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            _buildOptionItem(
              context: context,
              icon: Icons.block_outlined,
              label: 'Block Contact',
              isDestructive: true,
              onTap: () {
                Get.back();
                _showBlockConfirmation(context);
              },
            ),
            const SizedBox(height: 8),
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

  void _showBlockConfirmation(BuildContext context) {
    final isDark = context.isDark;

    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColorsDark.surface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Block ${contact.name}?',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: context.textPrimaryColor,
          ),
        ),
        content: Text(
          'They will no longer be able to contact you or see your profile.',
          style: TextStyle(
            color: context.textSecondaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: context.textSecondaryColor.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact blocked'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text(
              'Block',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
