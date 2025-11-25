import 'package:get/get.dart';

import '../../../core/utils/error_handler.dart';
import '../../../core/widgets/snackbar_extension.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_pages.dart';

class SettingsController extends GetxController {
  final FirestoreService _firestoreService = Get.find();
  final AuthService _authService = Get.find();

  final currentUser = Rxn<UserModel>();
  final isLoading = false.obs;
  final notificationsEnabled = true.obs;
  final userStatus = 'Online'.obs;

  late String _currentUserId;

  @override
  void onInit() {
    super.onInit();
    _currentUserId = _authService.currentUser?.uid ?? '';
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      isLoading.value = true;
      final user = await _firestoreService.getUser(_currentUserId);
      if (user != null) {
        currentUser.value = user;
      }
    } catch (e) {
      if (Get.context != null && Get.context!.mounted) {
        ErrorHandler.handleFirestoreError(Get.context!, e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    if (Get.context != null && Get.context!.mounted) {
      Get.context!.showInfoSnackBar(
        message: value ? 'Notifications enabled' : 'Notifications disabled',
      );
    }
  }

  void onPrivacyTapped() {
    if (Get.context != null && Get.context!.mounted) {
      Get.context!.showInfoSnackBar(message: 'Privacy settings coming soon!');
    }
  }

  void onAppearanceTapped() {
    if (Get.context != null && Get.context!.mounted) {
      Get.context!.showInfoSnackBar(message: 'Appearance settings coming soon!');
    }
  }

  void onHelpSupportTapped() {
    if (Get.context != null && Get.context!.mounted) {
      Get.context!.showInfoSnackBar(message: 'Help & Support coming soon!');
    }
  }

  void onEditProfileTapped() {
    if (Get.context != null && Get.context!.mounted) {
      Get.context!.showInfoSnackBar(message: 'Edit profile coming soon!');
    }
  }

  void onPhoneTapped() {
    if (Get.context != null && Get.context!.mounted) {
      Get.context!.showInfoSnackBar(message: 'Phone settings coming soon!');
    }
  }

  void onEmailTapped() {
    if (Get.context != null && Get.context!.mounted) {
      Get.context!.showInfoSnackBar(message: 'Email settings coming soon!');
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      if (Get.context != null && Get.context!.mounted) {
        ErrorHandler.showSuccessSnackbar(
          Get.context!,
          'Signed out successfully',
        );
      }
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      if (Get.context != null && Get.context!.mounted) {
        ErrorHandler.handleAuthError(Get.context!, e);
      }
    }
  }
}
