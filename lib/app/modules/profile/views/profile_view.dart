import 'dart:math' as math;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_helper.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.screenBackgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState(context);
        }

        if (controller.user.value == null) {
          return _buildErrorState(context);
        }

        return _buildProfileContent(context);
      }),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: context.primaryColor,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading profile...',
            style: TextStyle(
              fontSize: 16,
              color: context.textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
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
              Icons.person_off_outlined,
              size: 56,
              color: context.primaryColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'User not found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This profile may no longer exist',
            style: TextStyle(fontSize: 15, color: context.textSecondaryColor),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.gradientStartColor,
                    context.gradientEndColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Go Back',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background decorative elements
        _buildBackgroundDecorations(context),

        // Main content
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Hero header section
              _buildHeroHeader(context, screenHeight),

              // Profile info section
              _buildProfileInfo(context),

              // Action buttons
              _buildActionButtons(context),

              // Additional info cards
              _buildInfoCards(context),

              // Danger zone
              if (!controller.isCurrentUser.value) _buildDangerZone(context),

              const SizedBox(height: 40),
            ],
          ),
        ),

        // Back button
        _buildBackButton(context),

        // Options menu button
        if (!controller.isCurrentUser.value) _buildOptionsButton(context),
      ],
    );
  }

  Widget _buildBackgroundDecorations(BuildContext context) {
    final isDark = context.isDark;

    return Stack(
      children: [
        // Top gradient blob
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  context.primaryColor.withValues(alpha: isDark ? 0.15 : 0.1),
                  context.primaryColor.withValues(alpha: 0.02),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom left blob
        Positioned(
          bottom: 200,
          left: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  context.gradientEndColor.withValues(
                    alpha: isDark ? 0.12 : 0.08,
                  ),
                  context.gradientEndColor.withValues(alpha: 0.02),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Decorative dots pattern
        Positioned(top: 180, left: 30, child: _buildDotsPattern(context)),
        Positioned(
          bottom: 300,
          right: 20,
          child: Transform.rotate(
            angle: math.pi / 6,
            child: _buildDotsPattern(context),
          ),
        ),
      ],
    );
  }

  Widget _buildDotsPattern(BuildContext context) {
    return Opacity(
      opacity: context.isDark ? 0.15 : 0.25,
      child: SizedBox(
        width: 50,
        height: 50,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: 16,
          itemBuilder: (context, index) {
            return Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: context.primaryColor,
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context, double screenHeight) {
    final user = controller.user.value!;
    final isDark = context.isDark;

    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: SlideTransition(
            position: controller.slideAnimation,
            child: child,
          ),
        );
      },
      child: SizedBox(
        height: screenHeight * 0.42,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Gradient header background
            Container(
              height: screenHeight * 0.28,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.gradientStartColor,
                    context.gradientEndColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Decorative circles in header
                  Positioned(
                    top: -30,
                    right: -30,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: -40,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  // Wave pattern at bottom
                  Positioned(
                    bottom: -1,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 50),
                      painter: WavePainter(
                        color: isDark
                            ? AppColorsDark.background
                            : const Color(0xFFF8FFFE),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Avatar - positioned to overlap
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  // Avatar with glow effect
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: context.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: isDark ? 0.2 : 1),
                            Colors.white.withValues(alpha: isDark ? 0.1 : 0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: isDark ? AppColorsDark.surface : Colors.white,
                          width: 4,
                        ),
                      ),
                      child: _buildAvatar(context, user),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    user.name.isNotEmpty ? user.name : 'Unknown User',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimaryColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Online status
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       width: 10,
                  //       height: 10,
                  //       decoration: BoxDecoration(
                  //         color: controller.isOnline ? context.accentColor : Colors.grey,
                  //         shape: BoxShape.circle,
                  //         boxShadow: controller.isOnline
                  //             ? [
                  //                 BoxShadow(
                  //                   color: context.accentColor.withValues(alpha: 0.5),
                  //                   blurRadius: 8,
                  //                   spreadRadius: 2,
                  //                 ),
                  //               ]
                  //             : null,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 8),
                  //     Text(
                  //       controller.isOnline ? 'Online' : 'Offline',
                  //       style: TextStyle(
                  //         fontSize: 15,
                  //         fontWeight: FontWeight.w500,
                  //         color: controller.isOnline
                  //             ? context.accentColor
                  //             : context.textSecondaryColor,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, dynamic user) {
    final photoUrl = user.photoUrl as String?;
    final name = user.name as String? ?? '';

    return ClipOval(
      child: photoUrl != null && photoUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: photoUrl,
              width: 130,
              height: 130,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  _buildAvatarPlaceholder(context, name),
              errorWidget: (context, url, error) =>
                  _buildAvatarPlaceholder(context, name),
            )
          : _buildAvatarPlaceholder(context, name),
    );
  }

  Widget _buildAvatarPlaceholder(BuildContext context, String name) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColor.withValues(alpha: 0.2),
            context.gradientEndColor.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          controller.initials,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: context.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    final user = controller.user.value!;
    final isDark = context.isDark;

    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        final delayedAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller.animationController,
            curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
          ),
        );
        return FadeTransition(opacity: delayedAnimation, child: child);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? AppColorsDark.surface.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? AppColorsDark.border.withValues(alpha: 0.2)
                : Colors.white,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : context.primaryColor.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              children: [
                _buildInfoRow(
                  context: context,
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: user.email,
                ),
                Divider(
                  height: 28,
                  color: context.dividerColor.withValues(alpha: 0.2),
                ),
                _buildInfoRow(
                  context: context,
                  icon: Icons.calendar_month_outlined,
                  label: 'Member Since',
                  value: controller.memberSince,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: context.primaryColor, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: context.textSecondaryColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : '-',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (controller.isCurrentUser.value) {
      return const SizedBox(height: 24);
    }

    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        final delayedAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller.animationController,
            curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
          ),
        );
        return FadeTransition(opacity: delayedAnimation, child: child);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Row(
          children: [
            // Message button - primary action
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => controller.startChat(),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.gradientStartColor,
                        context.gradientEndColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: context.primaryColor.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Message',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context) {
    final isDark = context.isDark;

    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        final delayedAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller.animationController,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
          ),
        );
        return FadeTransition(opacity: delayedAnimation, child: child);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? AppColorsDark.surface.withValues(alpha: 0.6)
                : context.primaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: context.primaryColor.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: context.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verified Account',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'This account has been verified',
                      style: TextStyle(
                        fontSize: 13,
                        color: context.textSecondaryColor.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.check_circle_rounded,
                color: context.accentColor,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Privacy',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.textSecondaryColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColorsDark.surface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.dividerColor.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                _buildDangerOption(
                  context: context,
                  icon: Icons.block_outlined,
                  label: 'Block User',
                  subtitle: 'Stop receiving messages from this user',
                  onTap: () => _showBlockDialog(context),
                ),
                Divider(
                  height: 1,
                  indent: 60,
                  color: context.dividerColor.withValues(alpha: 0.2),
                ),
                _buildDangerOption(
                  context: context,
                  icon: Icons.flag_outlined,
                  label: 'Report User',
                  subtitle: 'Report inappropriate behavior',
                  onTap: () => _showReportDialog(context),
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(isLast ? 0 : 16),
        bottom: Radius.circular(isLast ? 16 : 0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.red.shade400, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade400,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.textSecondaryColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.textSecondaryColor.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      child: GestureDetector(
        onTap: () => controller.goBack(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      right: 16,
      child: GestureDetector(
        onTap: () => _showOptionsMenu(context),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.more_horiz_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
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
            _buildOptionItem(
              context: context,
              icon: Icons.share_outlined,
              label: 'Share Profile',
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
              icon: Icons.copy_rounded,
              label: 'Copy Profile Link',
              onTap: () {
                Get.back();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Profile link copied!'),
                    backgroundColor: context.primaryColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
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
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: context.primaryColor, size: 22),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: context.textPrimaryColor,
        ),
      ),
    );
  }

  void _showBlockDialog(BuildContext context) {
    final isDark = context.isDark;
    final userName = controller.user.value?.name ?? 'this user';

    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColorsDark.surface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Block $userName?',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: context.textPrimaryColor,
          ),
        ),
        content: Text(
          'They will no longer be able to contact you or see when you\'re online.',
          style: TextStyle(color: context.textSecondaryColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: context.textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.blockUser();
            },
            child: const Text(
              'Block',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
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
              'Report User',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: context.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Why are you reporting this user?',
              style: TextStyle(fontSize: 14, color: context.textSecondaryColor),
            ),
            const SizedBox(height: 20),
            _buildReportOption(context, 'Spam or misleading'),
            _buildReportOption(context, 'Harassment or bullying'),
            _buildReportOption(context, 'Inappropriate content'),
            _buildReportOption(context, 'Fake account'),
            _buildReportOption(context, 'Other'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildReportOption(BuildContext context, String reason) {
    return InkWell(
      onTap: () {
        Get.back();
        controller.reportUser(reason);
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                reason,
                style: TextStyle(fontSize: 16, color: context.textPrimaryColor),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.textSecondaryColor.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom wave painter for header bottom
class WavePainter extends CustomPainter {
  final Color color;

  WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.5);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.5,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.4,
    );

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
