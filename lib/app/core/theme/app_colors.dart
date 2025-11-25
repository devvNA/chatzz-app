import 'package:flutter/material.dart';

class AppColors {
  // Primary colors (shared)
  static const primary = Color(0xFF00D09C);
  static const primaryDark = Color(0xFF00B089);
  static const accent = Color(0xFF48BB78);

  // Light theme colors
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF2D3748);
  static const textSecondary = Color(0xFF718096);
  static const incomingBubble = Color(0xFFE8F5F3);
  static const outgoingBubble = Color(0xFFFFFFFF);

  // Gradient colors (light)
  static const gradientStart = Color(0xFF5DC286);
  static const gradientEnd = Color(0xFF00B089);
  static const softGradientStart = Color(0xFFE0F7F2);
  static const softGradientEnd = Color(0xFFC8F0E8);

  // Alert colors
  static const Color error = Color(0xFFC63323);
  static const Color success = Color(0xFF0D936B);
  static const Color warning = Color(0xFFedb95e);
  static const Color info = Color(0xFF3182CE);
}

class AppColorsDark {
  // Primary colors (slightly adjusted for dark theme)
  static const primary = Color(0xFF00E5AD);
  static const primaryDark = Color(0xFF00C99A);
  static const accent = Color(0xFF5CD98F);

  // Dark theme backgrounds
  static const background = Color(0xFF0D0D14);
  static const surface = Color(0xFF1A1A2E);
  static const surfaceLight = Color(0xFF252542);
  static const card = Color(0xFF16213E);

  // Dark theme text colors
  static const textPrimary = Color(0xFFF7FAFC);
  static const textSecondary = Color(0xFFA0AEC0);
  static const textTertiary = Color(0xFF718096);

  // Dark theme bubbles
  static const incomingBubble = Color(0xFF252542);
  static const outgoingBubble = Color(0xFF16213E);

  // Dark theme gradients
  static const gradientStart = Color(0xFF00E5AD);
  static const gradientEnd = Color(0xFF00B089);
  static const softGradientStart = Color(0xFF1A2F3D);
  static const softGradientEnd = Color(0xFF162A36);

  // Dark divider/border
  static const divider = Color(0xFF2D3748);
  static const border = Color(0xFF3D4A5C);

  // Alert colors (adjusted for dark)
  static const Color error = Color(0xFFFC5C65);
  static const Color success = Color(0xFF26DE81);
  static const Color warning = Color(0xFFFED330);
  static const Color info = Color(0xFF4DABF7);
}
