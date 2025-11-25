import 'package:get/get.dart';

import '../../../core/utils/error_handler.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final FirestoreService _firestoreService = Get.find();
  final AuthService _authService = Get.find();

  final conversations = <ConversationModel>[].obs;
  final isLoading = false.obs;
  final currentUser = Rxn<UserModel>();

  late String _currentUserId;

  final Map<String, Map<String, dynamic>> _userInfoCache = {};

  @override
  void onInit() {
    super.onInit();
    _currentUserId = _authService.currentUser?.uid ?? '';
    _loadCurrentUser();
    _loadConversations();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _firestoreService.getUser(_currentUserId);
      if (user != null) {
        currentUser.value = user;
      }
    } catch (e) {
      if (Get.context != null && Get.context!.mounted) {
        ErrorHandler.handleFirestoreError(Get.context!, e);
      }
    }
  }

  void _loadConversations() {
    try {
      _firestoreService.getConversations(_currentUserId).listen(
        (conversationList) {
          conversations.value = conversationList;
        },
        onError: (error) {
          if (Get.context != null && Get.context!.mounted) {
            ErrorHandler.handleFirestoreError(Get.context!, error);
          }
        },
      );
    } catch (e) {
      if (Get.context != null && Get.context!.mounted) {
        ErrorHandler.handleFirestoreError(Get.context!, e);
      }
    }
  }

  Future<Map<String, dynamic>> getOtherParticipantInfo(
    ConversationModel conversation,
  ) async {
    try {
      final otherUserId = conversation.participants.firstWhere(
        (id) => id != _currentUserId,
        orElse: () => '',
      );

      if (otherUserId.isEmpty) {
        return {'name': 'Unknown', 'photoUrl': null};
      }

      if (_userInfoCache.containsKey(otherUserId)) {
        return _userInfoCache[otherUserId]!;
      }

      final user = await _firestoreService.getUser(otherUserId);
      final info = {
        'name': user?.name ?? 'Unknown',
        'photoUrl': user?.photoUrl,
      };

      _userInfoCache[otherUserId] = info;

      return info;
    } catch (e) {
      return {'name': 'Unknown', 'photoUrl': null};
    }
  }

  Future<String> getOtherParticipantName(ConversationModel conversation) async {
    final info = await getOtherParticipantInfo(conversation);
    return info['name'] as String;
  }

  void navigateToNewChat() {
    Get.toNamed(Routes.NEW_CHAT);
  }
}
