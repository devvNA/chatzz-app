import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../home/views/home_view.dart';
import '../../settings/views/settings_view.dart';
import '../controllers/base_controller.dart';

class BaseView extends GetView<BaseController> {
  const BaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      extendBody: true,
      body: Stack(
        children: [
          // Body content
          Obx(() => _buildBody()),
          // Floating bottom navigation bar
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
        return _buildComingSoonPage('Contacts', Icons.group_rounded);
      case 2:
        return _buildComingSoonPage('Explore', Icons.explore_rounded);
      case 3:
        return const SettingsView();
      default:
        return const HomeView();
    }
  }

  Widget _buildComingSoonPage(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 56,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBottomNavBar(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Obx(
      () => Container(
        margin: EdgeInsets.fromLTRB(24, 0, 24, 16 + bottomPadding),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.softGradientStart, AppColors.softGradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
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
                icon: Icons.chat_bubble_rounded,
                label: 'Chats',
                index: 0,
                isSelected: controller.selectedIndex.value == 0,
              ),
              _buildNavItem(
                icon: Icons.group_rounded,
                label: 'Contacts',
                index: 1,
                isSelected: controller.selectedIndex.value == 1,
              ),
              _buildNavItem(
                icon: Icons.explore_rounded,
                label: 'Explore',
                index: 2,
                isSelected: controller.selectedIndex.value == 2,
              ),
              _buildNavItem(
                icon: Icons.settings_rounded,
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
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    bool showBadge = false,
  }) {
    final color = isSelected
        ? const Color(0xFF005C4B)
        : const Color(0xFF588B7E);

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
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
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
