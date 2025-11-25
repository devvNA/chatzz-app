import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/theme_helper.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: context.settingsBackgroundColor,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildProfileHeader(context, controller),
                const SizedBox(height: 24),
                _buildPersonalInfoCard(context, controller),
                const SizedBox(height: 16),
                _buildSettingsCard(context, controller),
                const SizedBox(height: 16),
                _buildLogoutButton(context, controller),
                const SizedBox(height: 130),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    SettingsController controller,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      child: Column(
        children: [
          Obx(() => _buildAvatar(context, controller)),
          const SizedBox(height: 20),
          Obx(
            () => Text(
              controller.currentUser.value?.name ?? 'User',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: context.textPrimaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => controller.onEditProfileTapped(),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: context.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    controller.userStatus.value,
                    style: TextStyle(
                      fontSize: 15,
                      color: context.textSecondaryColor.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: context.textSecondaryColor.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, SettingsController controller) {
    final user = controller.currentUser.value;
    final photoUrl = user?.photoUrl;
    final name = user?.name ?? '';

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: context.isDark
                  ? [
                      AppColorsDark.primary.withValues(alpha: 0.3),
                      AppColorsDark.gradientEnd.withValues(alpha: 0.3),
                    ]
                  : [
                      AppColors.primary.withValues(alpha: 0.3),
                      AppColors.gradientEnd.withValues(alpha: 0.3),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: context.isDark ? AppColorsDark.surface : Colors.white,
                width: 4,
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
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: context.accentColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: context.isDark ? AppColorsDark.surface : Colors.white,
                width: 3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarPlaceholder(BuildContext context, String name) {
    return Container(
      color: context.isDark
          ? AppColorsDark.primary.withValues(alpha: 0.2)
          : AppColors.primary.withValues(alpha: 0.2),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w600,
            color: context.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard(
    BuildContext context,
    SettingsController controller,
  ) {
    return _buildSection(
      context: context,
      title: 'Personal Information',
      children: [
        _buildInfoRow(
          context: context,
          icon: Icons.phone_outlined,
          label: '0821-4218-5804',
          onTap: () => controller.onPhoneTapped(),
        ),
        _buildDivider(context),
        Obx(
          () => _buildInfoRow(
            context: context,
            icon: Icons.email_outlined,
            label: controller.currentUser.value?.email ?? 'email@example.com',
            onTap: () => controller.onEmailTapped(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    SettingsController controller,
  ) {
    final themeController = Get.find<ThemeController>();

    return _buildSection(
      context: context,
      title: 'Settings',
      children: [
        _buildSettingsRowWithToggle(
          context: context,
          icon: Icons.notifications_outlined,
          label: 'Notifications',
          value: controller.notificationsEnabled.value,
          onChanged: controller.toggleNotifications,
        ),
        _buildDivider(context),
        _buildSettingsRow(
          context: context,
          icon: Icons.lock_outline,
          label: 'Privacy',
          onTap: () => controller.onPrivacyTapped(),
        ),
        _buildDivider(context),
        Obx(
          () => _buildSettingsRowWithToggle(
            context: context,
            icon: themeController.isDarkMode
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
            label: 'Dark Mode',
            value: themeController.isDarkMode,
            onChanged: controller.toggleDarkMode,
          ),
        ),
        _buildDivider(context),
        _buildSettingsRow(
          context: context,
          icon: Icons.help_outline_rounded,
          label: 'Help & Support',
          onTap: () => controller.onHelpSupportTapped(),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 32,
      color: context.isDark
          ? AppColorsDark.divider.withValues(alpha: 0.3)
          : AppColors.primary.withValues(alpha: 0.15),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: context.isDark
              ? [AppColorsDark.surface, AppColorsDark.surfaceLight]
              : [AppColors.softGradientStart, AppColors.softGradientEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: context.isDark
              ? AppColorsDark.border.withValues(alpha: 0.2)
              : Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: context.isDark
                ? Colors.black.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.isDark
                  ? AppColorsDark.primary
                  : AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.isDark
                  ? AppColorsDark.primary.withValues(alpha: 0.15)
                  : AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: context.isDark
                  ? AppColorsDark.primary
                  : AppColors.primaryDark,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: context.textPrimaryColor,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: context.isDark
                ? AppColorsDark.textSecondary.withValues(alpha: 0.5)
                : AppColors.textSecondary.withValues(alpha: 0.5),
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRowWithToggle({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.isDark
                  ? AppColorsDark.primary.withValues(alpha: 0.15)
                  : AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: context.isDark
                  ? AppColorsDark.primary
                  : AppColors.primaryDark,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: context.textPrimaryColor,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: (value) {
              onChanged(value);
              controller.update();
            },
            activeColor: Colors.white,
            activeTrackColor: context.primaryColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: context.isDark
                ? AppColorsDark.surfaceLight
                : Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.isDark
                    ? AppColorsDark.primary.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: context.isDark
                    ? AppColorsDark.primary
                    : AppColors.primaryDark,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: context.textPrimaryColor,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.isDark
                  ? AppColorsDark.textSecondary.withValues(alpha: 0.5)
                  : AppColors.textSecondary.withValues(alpha: 0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    SettingsController controller,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutConfirmation(context, controller),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.logout_rounded, size: 22),
        label: const Text(
          'Logout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(
    BuildContext context,
    SettingsController controller,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: context.isDark ? AppColorsDark.surface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: context.textPrimaryColor,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: context.textSecondaryColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: context.isDark
                    ? AppColorsDark.textSecondary.withValues(alpha: 0.8)
                    : AppColors.textSecondary.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.signOut();
            },
            child: Text(
              'Logout',
              style: TextStyle(
                color: context.isDark ? AppColorsDark.error : AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
