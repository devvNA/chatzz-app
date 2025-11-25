import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

// Light Theme
ThemeData myTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: AppColors.textPrimary,
    displayColor: AppColors.textPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: const StadiumBorder(),
      maximumSize: const Size(double.infinity, 56),
      minimumSize: const Size(double.infinity, 56),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    iconColor: AppColors.primary,
    prefixIconColor: AppColors.primary,
    hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.6)),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 16.0,
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  dividerTheme: DividerThemeData(color: Colors.grey.shade200, thickness: 1),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return Colors.white;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return Colors.grey.shade300;
    }),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    contentTextStyle: GoogleFonts.poppins(
      fontSize: 16,
      color: AppColors.textSecondary,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  ),
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    surface: AppColors.surface,
    error: AppColors.error,
  ),
);

// Dark Theme
ThemeData myDarkTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.dark,
  primaryColor: AppColorsDark.primary,
  scaffoldBackgroundColor: AppColorsDark.background,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColorsDark.surface,
    foregroundColor: AppColorsDark.textPrimary,
    elevation: 0,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(
    bodyColor: AppColorsDark.textPrimary,
    displayColor: AppColorsDark.textPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColorsDark.primary,
      foregroundColor: AppColorsDark.background,
      shape: const StadiumBorder(),
      maximumSize: const Size(double.infinity, 56),
      minimumSize: const Size(double.infinity, 56),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColorsDark.surface,
    iconColor: AppColorsDark.primary,
    prefixIconColor: AppColorsDark.primary,
    hintStyle: TextStyle(
      color: AppColorsDark.textSecondary.withValues(alpha: 0.6),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 16.0,
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(
        color: AppColorsDark.border.withValues(alpha: 0.3),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(color: AppColorsDark.primary, width: 2),
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColorsDark.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: AppColorsDark.border.withValues(alpha: 0.2)),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColorsDark.divider,
    thickness: 1,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColorsDark.background;
      }
      return Colors.grey.shade400;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColorsDark.primary;
      }
      return AppColorsDark.surfaceLight;
    }),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColorsDark.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColorsDark.textPrimary,
    ),
    contentTextStyle: GoogleFonts.poppins(
      fontSize: 16,
      color: AppColorsDark.textSecondary,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColorsDark.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  ),
  colorScheme: const ColorScheme.dark(
    primary: AppColorsDark.primary,
    secondary: AppColorsDark.accent,
    surface: AppColorsDark.surface,
    error: AppColorsDark.error,
  ),
);
