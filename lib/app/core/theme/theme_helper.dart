import 'package:flutter/material.dart';

import 'app_colors.dart';

extension ThemeHelper on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Primary colors
  Color get primaryColor => isDark ? AppColorsDark.primary : AppColors.primary;
  Color get primaryDarkColor =>
      isDark ? AppColorsDark.primaryDark : AppColors.primaryDark;
  Color get accentColor => isDark ? AppColorsDark.accent : AppColors.accent;

  // Background colors
  Color get backgroundColor =>
      isDark ? AppColorsDark.background : AppColors.background;
  Color get surfaceColor => isDark ? AppColorsDark.surface : AppColors.surface;
  Color get surfaceLightColor =>
      isDark ? AppColorsDark.surfaceLight : AppColors.surface;

  // Text colors
  Color get textPrimaryColor =>
      isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
  Color get textSecondaryColor =>
      isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;

  // Gradient colors
  Color get gradientStartColor =>
      isDark ? AppColorsDark.gradientStart : AppColors.gradientStart;
  Color get gradientEndColor =>
      isDark ? AppColorsDark.gradientEnd : AppColors.gradientEnd;
  Color get softGradientStartColor =>
      isDark ? AppColorsDark.softGradientStart : AppColors.softGradientStart;
  Color get softGradientEndColor =>
      isDark ? AppColorsDark.softGradientEnd : AppColors.softGradientEnd;

  // Bubble colors
  Color get incomingBubbleColor =>
      isDark ? AppColorsDark.incomingBubble : AppColors.incomingBubble;
  Color get outgoingBubbleColor =>
      isDark ? AppColorsDark.outgoingBubble : AppColors.outgoingBubble;

  // Border/Divider
  Color get dividerColor =>
      isDark ? AppColorsDark.divider : Colors.grey.shade200;
  Color get borderColor => isDark ? AppColorsDark.border : Colors.grey.shade300;

  // Card background for light theme screens
  Color get screenBackgroundColor =>
      isDark ? AppColorsDark.background : const Color(0xFFF8FFFE);

  Color get settingsBackgroundColor =>
      isDark ? AppColorsDark.background : const Color(0xFFF0F9F6);
}
