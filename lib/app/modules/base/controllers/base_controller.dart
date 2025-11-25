import 'package:get/get.dart';

import '../../../core/utils/error_handler.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_pages.dart';

class BaseController extends GetxController {
  final FirestoreService _firestoreService = Get.find();
  final AuthService _authService = Get.find();

  final selectedIndex = 0.obs;
  final currentUser = Rxn<UserModel>();

  late String currentUserId;

  @override
  void onInit() {
    super.onInit();
    currentUserId = _authService.currentUser?.uid ?? '';
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _firestoreService.getUser(currentUserId);
      if (user != null) {
        currentUser.value = user;
      }
    } catch (e) {
      if (Get.context != null && Get.context!.mounted) {
        ErrorHandler.handleFirestoreError(Get.context!, e);
      }
    }
  }

  void onNavItemTapped(int index) {
    if (index == selectedIndex.value) return;
    selectedIndex.value = index;
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
