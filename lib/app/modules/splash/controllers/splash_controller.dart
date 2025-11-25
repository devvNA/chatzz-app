import 'dart:developer';

import 'package:chatzz/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../../../core/utils/error_handler.dart';
import '../../../data/services/auth_service.dart';

class SplashController extends GetxController {
  late final AuthService _authService;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
    _checkSession();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Check if user has valid session and navigate accordingly
  Future<void> _checkSession() async {
    // Add a small delay for splash screen visibility
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Check if session token exists and is valid
      final isValid = await _authService.validateSession();
      log('SplashController: Session validation result: $isValid');

      if (isValid) {
        // User has valid session, navigate to base (with bottom nav)
        log('SplashController: Navigating to BASE');
        Get.offAllNamed(Routes.BASE);
        log('SplashController: Navigation to BASE completed');
      } else {
        // No valid session, navigate to login
        log('SplashController: Navigating to LOGIN (invalid session)');
        Get.offAllNamed(Routes.LOGIN);
        log('SplashController: Navigation to LOGIN completed');
      }
    } catch (e) {
      // On error, log and navigate to login
      log('Splash error: $e');
      log('SplashController: Navigating to LOGIN (error occurred)');

      // Show error message to user
      ErrorHandler.showErrorSnackbar(
        Get.context!,
        'Failed to validate session. Please login again.',
      );

      Get.offAllNamed(Routes.LOGIN);
      log('SplashController: Navigation to LOGIN completed (after error)');
    }
  }
}
