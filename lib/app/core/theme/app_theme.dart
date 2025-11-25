import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData myTheme = ThemeData(
  useMaterial3: false,
  appBarTheme: const AppBarTheme(backgroundColor: AppColors.primary),
  textTheme: GoogleFonts.poppinsTextTheme(),
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: Colors.white,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.primary,
      shape: const StadiumBorder(),
      maximumSize: const Size(double.infinity, 56),
      minimumSize: const Size(double.infinity, 56),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.background,
    iconColor: AppColors.primary,
    prefixIconColor: AppColors.primary,
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide.none,
    ),
  ),
);
