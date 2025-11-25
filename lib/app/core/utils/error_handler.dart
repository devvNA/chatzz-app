import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/snackbar_extension.dart';

/// Centralized error handling utility
class ErrorHandler {
  ErrorHandler._();

  /// Handle and display Firebase Auth errors
  static void handleAuthError(BuildContext context, dynamic error) {
    String message;

    if (error is FirebaseAuthException) {
      message = _getAuthErrorMessage(error);
    } else {
      message = 'An unexpected error occurred';
    }

    context.showErrorSnackBar(message: message);
  }

  /// Handle and display Firestore errors
  static void handleFirestoreError(BuildContext context, dynamic error) {
    String message;

    if (error is FirebaseException) {
      message = _getFirestoreErrorMessage(error);
    } else {
      message = 'An unexpected error occurred';
    }

    context.showErrorSnackBar(message: message);
  }

  /// Handle generic errors
  static void handleError(
    BuildContext context,
    dynamic error, {
    String title = 'Error',
  }) {
    String message;

    if (error is FirebaseAuthException) {
      message = _getAuthErrorMessage(error);
    } else if (error is FirebaseException) {
      message = _getFirestoreErrorMessage(error);
    } else if (error is Exception) {
      message = error.toString().replaceFirst('Exception: ', '');
    } else {
      message = error.toString();
    }

    context.showErrorSnackBar(message: message);
  }

  /// Show error snackbar
  static void showErrorSnackbar(BuildContext context, String message) {
    context.showErrorSnackBar(message: message);
  }

  /// Show success snackbar
  static void showSuccessSnackbar(BuildContext context, String message) {
    context.showSuccessSnackBar(message: message);
  }

  /// Show warning snackbar
  static void showWarningSnackbar(BuildContext context, String message) {
    context.showWarningSnackBar(message: message);
  }

  /// Show info snackbar
  static void showInfoSnackbar(BuildContext context, String message) {
    context.showInfoSnackBar(message: message);
  }

  /// Get user-friendly message for Firebase Auth errors
  static String _getAuthErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak (minimum 6 characters)';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      case 'operation-not-allowed':
        return 'This operation is not allowed';
      default:
        return error.message ?? 'Authentication failed';
    }
  }

  /// Get user-friendly message for Firestore errors
  static String _getFirestoreErrorMessage(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'You do not have permission to perform this action';
      case 'not-found':
        return 'The requested data was not found';
      case 'unavailable':
        return 'Service temporarily unavailable. Please try again';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      case 'invalid-argument':
        return error.message ?? 'Invalid data provided';
      default:
        return error.message ?? 'Database operation failed';
    }
  }
}
