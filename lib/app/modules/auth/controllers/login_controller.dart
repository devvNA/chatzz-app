import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/error_handler.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Handle login using Either pattern
  Future<void> login(BuildContext context) async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text;

    isLoading.value = true;

    final result = await _authService.signIn(email, password);

    isLoading.value = false;

    result.fold(
      (failure) {
        ErrorHandler.showErrorSnackbar(context, failure.message);
      },
      (user) {
        Get.offAllNamed(Routes.BASE);
      },
    );
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
}
