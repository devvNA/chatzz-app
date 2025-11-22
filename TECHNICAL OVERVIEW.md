# Technical Overview - Chatzz

## Project Status
**Current State:** Initial Setup Phase  
**Version:** 1.0.0  
**Framework:** Flutter 3.10.0+  
**Language:** Dart  

This is a greenfield Flutter project with dependencies configured but no implementation yet. The codebase currently contains only the default Flutter counter app template.

---

## Core Components

### 1. Architecture Pattern
**GetX Pattern (MVC) + Clean Architecture**

The planned architecture follows a layered approach:

- **Presentation Layer** (Views + Controllers)
  - `lib/app/modules/` - Feature modules organized by screen
  - Each module contains: `view.dart`, `controller.dart`, `binding.dart`
  - GetX controllers manage UI state reactively
  
- **Domain Layer** (Business Logic)
  - `lib/app/data/models/` - Data models with `toJson()`, `copyWith()`, default values
  - Business rules and use cases
  
- **Data Layer** (Repositories & Services)
  - `lib/app/data/services/` - Firebase services (Auth, Firestore, Storage)
  - `lib/app/data/repositories/` - Data access abstraction
  - Local caching with GetStorage

### 2. State Management
**GetX Reactive State Manager**

- **Reactive Variables:** `.obs` observables for automatic UI updates
- **Controllers:** Extend `GetxController` for lifecycle management
- **Bindings:** Dependency injection via `Bindings` class
- **Navigation:** Named routes with `Get.toNamed()`, `Get.off()`, `Get.offAll()`

Key GetX features in use:
- `GetMaterialApp` as root widget
- `GetView<Controller>` for view-controller binding
- `Obx()` or `GetBuilder()` for reactive UI updates
- `Get.find<Controller>()` for dependency retrieval

### 3. Tech Stack Components

#### Backend as a Service (Firebase)
- **firebase_core** (^3.0.0) - Firebase initialization
- **firebase_auth** (^5.0.0) - Email/password authentication
- **cloud_firestore** (^5.0.0) - Real-time NoSQL database
- **firebase_storage** (^12.0.0) - Media file storage

#### Local Storage
- **get_storage** (^2.1.1) - Key-value storage for session persistence
- Planned: **isar** - Local database for offline message caching (not yet added)

#### Utilities
- **connectivity_plus** (^6.0.0) - Network status monitoring
- **image_picker** (^1.0.0) - Camera/gallery access
- **intl** (^0.19.0) - Date/time formatting
- **uuid** (^4.0.0) - Unique ID generation
- **cached_network_image** (^3.3.0) - Image caching

### 4. Planned Module Structure

```
lib/
├── main.dart                          # App entry point
├── app/
│   ├── routes/
│   │   ├── app_pages.dart            # Route definitions
│   │   └── app_routes.dart           # Route constants
│   ├── modules/
│   │   ├── splash/                   # Auto-login screen
│   │   ├── auth/
│   │   │   ├── login/
│   │   │   └── register/
│   │   ├── home/                     # Chat list screen
│   │   ├── chat/                     # Chat detail screen
│   │   └── profile/                  # User profile screen
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── message_model.dart
│   │   │   └── conversation_model.dart
│   │   ├── services/
│   │   │   ├── auth_service.dart
│   │   │   ├── firestore_service.dart
│   │   │   ├── storage_service.dart
│   │   │   └── connectivity_service.dart
│   │   └── repositories/
│   │       ├── user_repository.dart
│   │       └── message_repository.dart
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart       # Color palette
│   │   │   ├── app_text_styles.dart  # Typography
│   │   │   └── app_theme.dart        # ThemeData
│   │   ├── utils/
│   │   │   ├── constants.dart
│   │   │   └── helpers.dart
│   │   └── widgets/                  # Reusable components
│   │       ├── message_bubble.dart
│   │       ├── chat_list_item.dart
│   │       └── custom_text_field.dart
│   └── bindings/
│       └── initial_binding.dart      # Global dependencies
```

---

## Component Interactions

### 1. Data Flow Architecture

**User Action → Controller → Service/Repository → Firebase → Local Cache → UI Update**

```
[View] ←→ [Controller] ←→ [Repository] ←→ [Firebase Service]
                ↓                              ↓
           [GetStorage]                   [Firestore/Auth]
```

### 2. Authentication Flow
1. User submits credentials via `LoginView`
2. `LoginController` validates input
3. `AuthService.signIn()` calls Firebase Auth
4. On success: Save session to GetStorage
5. Navigate to HomeView via `Get.offAllNamed(Routes.HOME)`
6. `AuthMiddleware` checks session on app restart

### 3. Real-time Messaging Flow
1. `ChatController` subscribes to Firestore stream:
   ```dart
   firestore.collection('messages')
     .where('conversationId', isEqualTo: id)
     .orderBy('timestamp')
     .snapshots()
   ```
2. Stream updates trigger reactive UI rebuild via `.obs` variables
3. New messages auto-append to chat list
4. Local cache updated for offline access

### 4. Dependency Injection Pattern
```dart
// Binding
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => FirestoreService());
  }
}

// Usage in Controller
class HomeController extends GetxController {
  final FirestoreService _firestore = Get.find();
}
```

### 5. Navigation & Routing
- **Named Routes:** Defined in `app_pages.dart`
- **Route Guards:** Middleware checks authentication state
- **Deep Linking:** Supported via GetX route parameters

---

## Deployment Architecture

### 1. Build Configuration

**Android:**
```bash
flutter build apk --release
flutter build appbundle --release
```
- Output: `build/app/outputs/flutter-apk/app-release.apk`
- Requires: `android/app/google-services.json` (Firebase config)
- Signing: Configure `android/app/build.gradle.kts` with keystore

**iOS:**
```bash
flutter build ios --release
```
- Output: `build/ios/iphoneos/Runner.app`
- Requires: `ios/Runner/GoogleService-Info.plist` (Firebase config)
- Signing: Configure in Xcode with provisioning profile

### 2. Environment Setup

**Required:**
- Flutter SDK 3.10.0+
- Dart SDK (bundled with Flutter)
- Android Studio / Xcode (for platform builds)
- Firebase project with:
  - Authentication enabled (Email/Password)
  - Firestore database created
  - Storage bucket configured

**Firebase Configuration Steps:**
1. Create Firebase project at console.firebase.google.com
2. Add Android app → Download `google-services.json` → Place in `android/app/`
3. Add iOS app → Download `GoogleService-Info.plist` → Place in `ios/Runner/`
4. Run `flutterfire configure` (if using FlutterFire CLI)

### 3. External Dependencies

**Firebase Services:**
- Authentication API
- Cloud Firestore (NoSQL database)
- Cloud Storage (media files)

**Third-party APIs:**
- None currently (self-contained)

### 4. Environment Variables
- No `.env` file currently used
- Firebase config embedded in platform-specific files
- Consider adding for API keys in future phases

---

## Runtime Behavior

### 1. Application Initialization

**Startup Sequence:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize local storage
  await GetStorage.init();
  
  // Initialize global services
  Get.put(ConnectivityService(), permanent: true);
  Get.put(AuthService(), permanent: true);
  
  runApp(MyApp());
}
```

**Initial Route Logic:**
1. Check GetStorage for saved session token
2. If valid session exists → Navigate to `Routes.HOME`
3. If no session → Navigate to `Routes.LOGIN`
4. Show splash screen during check (2-3 seconds)

### 2. Request/Response Handling

**Firestore Operations:**
- **Create:** `collection.add(data)` or `doc.set(data)`
- **Read:** `doc.get()` (one-time) or `snapshots()` (real-time)
- **Update:** `doc.update(fields)`
- **Delete:** `doc.delete()`

**Error Handling Pattern:**
```dart
try {
  await firestoreService.sendMessage(message);
  Get.snackbar('Success', 'Message sent');
} on FirebaseException catch (e) {
  Get.snackbar('Error', e.message ?? 'Unknown error');
} catch (e) {
  Get.snackbar('Error', 'Something went wrong');
}
```

### 3. Business Workflows

**Send Message Workflow:**
1. User types message in `ChatView` input field
2. Tap send button → `ChatController.sendMessage()`
3. Create `MessageModel` with:
   - `id`: UUID
   - `senderId`: Current user ID
   - `text`: Message content
   - `timestamp`: `DateTime.now()`
   - `status`: 'sending'
4. Add to Firestore: `messages/{messageId}`
5. Update conversation's `lastMessage` field
6. Update local cache
7. UI updates automatically via stream listener
8. Change status to 'sent' when Firestore confirms

**Auto-Login Workflow:**
1. App launches → `SplashController` checks GetStorage
2. If `userToken` exists:
   - Validate with Firebase: `auth.currentUser`
   - If valid → `Get.offAllNamed(Routes.HOME)`
   - If invalid → Clear storage, go to login
3. If no token → `Get.offAllNamed(Routes.LOGIN)`

### 4. Error Handling Strategy

**Global Error Handling:**
- Network errors: Show snackbar with retry option
- Auth errors: Redirect to login screen
- Firestore errors: Log to console, show user-friendly message

**Connectivity Monitoring:**
```dart
ConnectivityService.stream.listen((status) {
  if (status == ConnectivityResult.none) {
    Get.snackbar('Offline', 'No internet connection',
      backgroundColor: Colors.red);
  }
});
```

### 5. Background Tasks
- **Message Sync:** Firestore handles real-time sync automatically
- **Image Upload:** Queued via Firebase Storage SDK
- **Session Refresh:** Handled by Firebase Auth SDK
- **Future:** Push notifications via FCM (Phase 2)

---

## Design System Implementation

### Color Palette (Defined in PRD)
```dart
class AppColors {
  static const primary = Color(0x00D09C);        // Teal Green
  static const primaryDark = Color(0x00B089);    // Pressed state
  static const accent = Color(0x48BB78);         // Online indicator
  static const background = Color(0xF5FAF8);     // Soft mint
  static const surface = Color(0xFFFFFF);        // Cards, bubbles
  
  // Message bubbles
  static const incomingBubble = Color(0xE8F5F3); // Soft mint
  static const outgoingBubble = Color(0xFFFFFF); // White
  
  // Text
  static const textPrimary = Color(0x2D3748);    // Dark slate
  static const textSecondary = Color(0x718096);  // Gray
}
```

### Typography
- Font: Roboto (Android) / SF Pro (iOS) - System default
- Sizes: 12sp (timestamp), 14-16sp (body), 18-20sp (titles)

---

## Testing Strategy (Planned)

### Unit Tests
- Model serialization (`toJson`, `fromJson`)
- Controller business logic
- Service methods (mocked Firebase)

### Widget Tests
- Custom widgets (MessageBubble, ChatListItem)
- Screen layouts
- User interactions

### Integration Tests
- End-to-end user flows
- Firebase integration (test environment)

**Test Location:** `test/` directory (not yet created)

---

## Security Considerations

1. **Firebase Security Rules:** Must be configured for:
   - Users can only read/write their own data
   - Message access restricted to conversation participants
   
2. **Input Validation:** Sanitize user input before Firestore writes

3. **Authentication:** Firebase Auth handles token management securely

4. **Data Privacy:** No sensitive data stored in GetStorage (only session tokens)

---

## Performance Optimizations

1. **Image Caching:** `cached_network_image` reduces network calls
2. **Lazy Loading:** GetX `lazyPut` defers controller instantiation
3. **Firestore Queries:** Indexed fields for fast lookups
4. **Offline Support:** Local cache with GetStorage/Isar
5. **Pagination:** Implement for chat history (load 20 messages at a time)

---

## Known Limitations & Future Work

**Current Limitations:**
- No implementation yet (template code only)
- Isar database not added to dependencies
- Firebase not configured
- No security rules defined

**Phase 2 Roadmap:**
- Push notifications (FCM)
- Group chat support
- Voice notes & video calls (WebRTC/Agora)
- End-to-end encryption
- Advanced search & filters

---

## Quick Start for Developers

1. **Clone & Install:**
   ```bash
   git clone <repo-url>
   cd chatzz
   flutter pub get
   ```

2. **Configure Firebase:**
   - Add `google-services.json` to `android/app/`
   - Add `GoogleService-Info.plist` to `ios/Runner/`

3. **Run:**
   ```bash
   flutter run
   ```

4. **Build:**
   ```bash
   flutter build apk --release  # Android
   flutter build ios --release  # iOS
   ```

---

**Last Updated:** November 22, 2025  
**Document Version:** 1.0
