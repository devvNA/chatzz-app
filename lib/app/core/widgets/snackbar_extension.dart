// snackbar_extension.dart
import 'package:chatzz/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

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
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
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
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: textColor ?? Colors.white,
                onPressed: onActionPressed ?? () {},
              )
            : null,
      ),
    );
  }

  /// SnackBar untuk pesan sukses
  void showSuccessSnackBar({
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    showCustomSnackBar(
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle,
    );
  }

  /// SnackBar untuk pesan error
  void showErrorSnackBar({
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    showCustomSnackBar(
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      backgroundColor: AppColors.error,
      icon: Icons.error,
    );
  }

  /// SnackBar untuk pesan warning
  void showWarningSnackBar({
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    showCustomSnackBar(
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      backgroundColor: AppColors.warning,
      icon: Icons.warning,
    );
  }

  /// SnackBar untuk pesan info
  void showInfoSnackBar({
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    showCustomSnackBar(
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      backgroundColor: AppColors.info,
      icon: Icons.info,
    );
  }
}
