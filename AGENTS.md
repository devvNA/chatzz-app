# AGENTS.md - Chatzz Development Guide

## Project Context
**Chatzz** is a Flutter instant messaging app using GetX pattern + Clean Architecture.  
**Status:** Initial setup phase - dependencies configured, no implementation yet.  
**PRD:** See `docs/PRD.md` for complete requirements and UI/UX guidelines.

---

## Tech Stack
- **Framework:** Flutter 3.10.0+, Dart
- **State Management:** GetX (reactive controllers, navigation, DI)
- **Backend:** Firebase (Auth, Firestore, Storage)
- **Local Storage:** GetStorage (session), Isar (planned for message cache)
- **Architecture:** GetX MVC + Clean Architecture layers

---

## Project Structure
```
lib/
├── main.dart
├── app/
│   ├── routes/          # Named routes (app_pages.dart, app_routes.dart)
│   ├── modules/         # Feature modules (splash, auth, home, chat, profile)
│   │   └── [feature]/
│   │       ├── view.dart
│   │       ├── controller.dart
│   │       └── binding.dart
│   ├── data/
│   │   ├── models/      # Data models (user, message, conversation)
│   │   ├── services/    # Firebase services (auth, firestore, storage)
│   │   └── repositories/
│   ├── core/
│   │   ├── theme/       # Colors, text styles, theme data
│   │   ├── utils/       # Constants, helpers
│   │   └── widgets/     # Reusable components
│   └── bindings/        # Global dependency injection
```

---

## Coding Standards

### Model Classes
All models MUST include:
```dart
class UserModel {
  final String id;
  final String name;
  final String email;
  
  UserModel({
    required this.id,
    this.name = '',  // Default values
    this.email = '',
  });
  
  // toJson method
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
  
  // fromJson factory
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
  );
  
  // copyWith method
  UserModel copyWith({String? id, String? name, String? email}) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
  );
}
```

### GetX Controllers
```dart
class HomeController extends GetxController {
  final conversations = <ConversationModel>[].obs;  // Reactive list
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }
  
  Future<void> fetchConversations() async {
    try {
      isLoading.value = true;
      // Fetch logic
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
```

### Views
```dart
class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatzz')),
      body: Obx(() => controller.isLoading.value
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(...)
      ),
    );
  }
}
```

### Bindings
```dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
```

---

## Design System

### Colors (AppColors class)
- Primary: `#00D09C` (Teal Green)
- Primary Dark: `#00B089`
- Accent: `#48BB78` (Online indicator)
- Background: `#F5FAF8` (Soft mint)
- Incoming Bubble: `#E8F5F3`
- Outgoing Bubble: `#FFFFFF`
- Text Primary: `#2D3748`
- Text Secondary: `#718096`

### Typography
- Font: System default (Roboto/SF Pro)
- Sizes: 12sp (timestamp), 14-16sp (body), 18-20sp (title)

### Spacing
- Base unit: 8dp (all spacing in multiples of 8)
- Screen padding: 16dp horizontal
- Section spacing: 24-32dp vertical

### UI Components
- Button height: 48-56dp
- Border radius: 8-12dp (buttons/inputs), 12-16dp (message bubbles)
- Avatar size: 48-56dp (list), 80-120dp (profile)

**Reference:** See `docs/design/` for screen mockups.

---

## Firebase Setup

### Required Files
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

### Initialization (in main.dart)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}
```

### Firestore Collections Structure
```
users/
  {userId}/
    - id: string
    - name: string
    - email: string
    - photoUrl: string
    - createdAt: timestamp

conversations/
  {conversationId}/
    - id: string
    - participants: array<string>
    - lastMessage: string
    - lastMessageTime: timestamp

messages/
  {messageId}/
    - id: string
    - conversationId: string
    - senderId: string
    - text: string
    - imageUrl: string (optional)
    - timestamp: timestamp
    - status: string (sending, sent, read)
```

---

## Common Tasks

### Add New Screen
1. Create folder: `lib/app/modules/[feature]/`
2. Create files: `view.dart`, `controller.dart`, `binding.dart`
3. Add route to `app_routes.dart`:
   ```dart
   static const FEATURE = '/feature';
   ```
4. Add page to `app_pages.dart`:
   ```dart
   GetPage(
     name: Routes.FEATURE,
     page: () => FeatureView(),
     binding: FeatureBinding(),
   ),
   ```

### Add Firebase Service Method
```dart
class FirestoreService extends GetxService {
  final _firestore = FirebaseFirestore.instance;
  
  Future<void> addMessage(MessageModel message) async {
    await _firestore
      .collection('messages')
      .doc(message.id)
      .set(message.toJson());
  }
  
  Stream<List<MessageModel>> getMessages(String conversationId) {
    return _firestore
      .collection('messages')
      .where('conversationId', isEqualTo: conversationId)
      .orderBy('timestamp')
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => MessageModel.fromJson(doc.data()))
        .toList());
  }
}
```

### Handle Network Connectivity
```dart
// In controller
final ConnectivityService _connectivity = Get.find();

@override
void onInit() {
  super.onInit();
  _connectivity.stream.listen((status) {
    if (status == ConnectivityResult.none) {
      Get.snackbar('Offline', 'No internet connection');
    }
  });
}
```

---

## Error Handling Pattern

```dart
try {
  await someAsyncOperation();
  Get.snackbar('Success', 'Operation completed',
    backgroundColor: AppColors.accent);
} on FirebaseException catch (e) {
  Get.snackbar('Firebase Error', e.message ?? 'Unknown error',
    backgroundColor: Colors.red);
} catch (e) {
  Get.snackbar('Error', 'Something went wrong',
    backgroundColor: Colors.red);
  debugPrint('Error: $e');
}
```

---

## Performance Tips

1. **Use `lazyPut` for controllers:** Only instantiate when needed
2. **Dispose streams:** Always cancel subscriptions in `onClose()`
3. **Optimize Firestore queries:** Use indexes, limit results
4. **Cache images:** Use `cached_network_image` for avatars
5. **Paginate lists:** Load 20-50 items at a time

---

## Troubleshooting

### Firebase not initialized
- Ensure `Firebase.initializeApp()` is called before `runApp()`
- Check `google-services.json` / `GoogleService-Info.plist` are in correct locations

### GetX controller not found
- Verify binding is added to route in `app_pages.dart`
- Use `Get.put()` or `Get.lazyPut()` in binding

### Hot reload not working
- Run `flutter clean` then `flutter pub get`
- Restart IDE

### Build errors after adding dependency
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

---

## Resources

- **PRD:** `docs/PRD.md` (full requirements)
- **Design Mockups:** `docs/design/` (screen references)
- **Technical Overview:** `TECHNICAL OVERVIEW.md`
- **Flutter Docs:** https://docs.flutter.dev
- **GetX Docs:** https://pub.dev/packages/get
- **Firebase Docs:** https://firebase.google.com/docs/flutter

---

## DO’s

* Organize code by **feature modules**
* Keep controllers single-responsibility
* Use `.obs` for reactive state
* Wrap reactive UI with `Obx()`
* Implement lifecycle methods (`onInit`, `onClose`)
* Use caching, pagination, debounce, and error handling
* Fetch latest docs with Context7 MCP before coding

---

## DON'Ts

* Don’t put business logic inside widgets
* Don’t mix UI code with data access
* Don’t overuse `.obs`
* Don’t create multiple controller instances accidentally
* Don’t load all data at once
* Don’t block the main thread with heavy tasks
* Don’t expose raw errors to users

---

**Last Updated:** November 22, 2025  
**Maintained by:** Development Team
