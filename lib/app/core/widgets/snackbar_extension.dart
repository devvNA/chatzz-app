import 'package:chatzz/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum SnackBarPosition { top, bottom }

extension SnackBarExtension on BuildContext {
  /// Menampilkan SnackBar dengan kustomisasi penuh
  void showCustomSnackBar({
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    IconData? icon,
    SnackBarPosition position = SnackBarPosition.bottom,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor ?? Colors.white),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(message, style: TextStyle(color: textColor)),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: behavior,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: position == SnackBarPosition.top
          ? EdgeInsets.only(
              bottom: MediaQuery.of(this).size.height - 100,
              left: 10,
              right: 10,
            )
          : null,
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: textColor ?? Colors.white,
              onPressed: onActionPressed ?? () {},
            )
          : null,
    );

    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  /// SnackBar untuk pesan sukses
  void showSuccessSnackBar({
    required String message,
    String? actionLabel,
    Color? textColor,
    VoidCallback? onActionPressed,
    SnackBarPosition position = SnackBarPosition.bottom,
  }) {
    showCustomSnackBar(
      textColor: textColor,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle,
      position: position,
    );
  }

  /// SnackBar untuk pesan error
  void showErrorSnackBar({
    required String message,
    String? actionLabel,
    Color? textColor,
    VoidCallback? onActionPressed,
    SnackBarPosition position = SnackBarPosition.bottom,
  }) {
    showCustomSnackBar(
      textColor: textColor,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      backgroundColor: AppColors.error,
      icon: Icons.error,
      position: position,
    );
  }

  /// SnackBar untuk pesan warning
  void showWarningSnackBar({
    required String message,
    String? actionLabel,
    Color? textColor,
    VoidCallback? onActionPressed,
    SnackBarPosition position = SnackBarPosition.bottom,
  }) {
    showCustomSnackBar(
      textColor: textColor,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      backgroundColor: AppColors.warning,
      icon: Icons.warning,
      position: position,
    );
  }

  /// SnackBar untuk pesan info
  void showInfoSnackBar({
    required String message,
    String? actionLabel,
    Color? textColor,
    VoidCallback? onActionPressed,
    SnackBarPosition position = SnackBarPosition.bottom,
  }) {
    showCustomSnackBar(
      textColor: textColor,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      backgroundColor: AppColors.info,
      icon: Icons.info,
      position: position,
    );
  }
}
