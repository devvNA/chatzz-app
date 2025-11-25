import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_helper.dart';
import '../../home/views/home_view.dart';
import '../../settings/views/settings_view.dart';
import '../controllers/base_controller.dart';

class BaseView extends GetView<BaseController> {
  const BaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.screenBackgroundColor,
      extendBody: true,
      body: Stack(
        children: [
          Obx(() => _buildBody()),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildFloatingBottomNavBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (controller.selectedIndex.value) {
      case 0:
        return const HomeView();
      case 1:
        return Builder(
          builder: (context) =>
              _buildComingSoonPage(context, 'Contacts', Icons.group_rounded),
        );
      case 2:
        return Builder(
          builder: (context) =>
              _buildComingSoonPage(context, 'Explore', Icons.explore_rounded),
        );
      case 3:
        return const SettingsView();
      default:
        return const HomeView();
    }
  }

  Widget _buildComingSoonPage(
    BuildContext context,
    String title,
    IconData icon,
  ) {
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
              icon,
              size: 56,
              color: context.primaryColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 16,
              color: context.textSecondaryColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBottomNavBar(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isDark = context.isDark;

    return Obx(
      () => Container(
        margin: EdgeInsets.fromLTRB(24, 0, 24, 16 + bottomPadding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColorsDark.surface, AppColorsDark.surfaceLight]
                : [AppColors.softGradientStart, AppColors.softGradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isDark
                ? AppColorsDark.border.withValues(alpha: 0.3)
                : Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.chat,
                label: 'Chats',
                index: 0,
                isSelected: controller.selectedIndex.value == 0,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.group_rounded,
                label: 'Contacts',
                index: 1,
                isSelected: controller.selectedIndex.value == 1,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.explore_rounded,
                label: 'Explore',
                index: 2,
                isSelected: controller.selectedIndex.value == 2,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.person_2_rounded,
                label: 'Profile',
                index: 3,
                isSelected: controller.selectedIndex.value == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    bool showBadge = false,
  }) {
    final isDark = context.isDark;

    final color = isSelected
        ? (isDark ? AppColorsDark.primary : const Color(0xFF005C4B))
        : (isDark ? AppColorsDark.textSecondary : const Color(0xFF588B7E));

    return GestureDetector(
      onTap: () => controller.onNavItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 28),
                if (showBadge)
                  Positioned(
                    top: 0,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: context.accentColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColorsDark.surface : Colors.white,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
