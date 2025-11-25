import 'package:chatzz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/error_handler.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';

class RegisterController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();

  final registerFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Handle registration using Either pattern
  Future<void> register(BuildContext context) async {
    FocusScope.of(context).unfocus();

    if (!registerFormKey.currentState!.validate()) {
      return;
    }

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    isLoading.value = true;

    final result = await _authService.register(email, password);

    await result.fold(
      (failure) async {
        isLoading.value = false;
        ErrorHandler.showErrorSnackbar(context, failure.message);
      },
      (user) async {
        final userModel = UserModel(id: user.uid, name: name, email: email);

        try {
          await _firestoreService.saveUser(userModel);
          isLoading.value = false;
          if (context.mounted) {
            ErrorHandler.showSuccessSnackbar(
              context,
              'Registration successful',
            );
          }
          Get.offAllNamed(Routes.BASE);
        } catch (e) {
          isLoading.value = false;
          if (context.mounted) {
            ErrorHandler.handleFirestoreError(context, e);
          }
        }
      },
    );
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }
}
