# Design Document - Chatzz Messaging App

## Overview

Chatzz is a Flutter messaging app using GetX for state management and Firebase for backend services. The architecture has three layers: Presentation (Views + Controllers), Domain (Models), and Data (Firebase Services). The app uses reactive state management with GetX observables and real-time data synchronization via Firestore streams.

## Architecture

### System Architecture

```
Views (UI) → Controllers (State) → Services (Firebase)
     ↑                                      ↓
     └──────── Reactive Updates ────────────┘
```

**Presentation Layer:** Views + Controllers handle UI and state
**Domain Layer:** Models define data structures
**Data Layer:** Services communicate with Firebase

### Key Components

- **Auth Module**: Login/Register views and controllers
- **Home Module**: Conversation list view and controller
- **Chat Module**: Message view and controller
- **Models**: User, Message, Conversation
- **Services**: AuthService, FirestoreService

## Components and Interfaces

### Core Modules

**1. Authentication Module**
- LoginView + LoginController
- RegisterView + RegisterController  
- AuthService: signIn(), register(), signOut()

**2. Home Module**
- HomeView + HomeController
- Displays conversation list from Firestore stream
- Handles navigation to chat screens

**3. Chat Module**
- ChatView + ChatController
- MessageBubble widget for display
- Streams messages from Firestore
- Sends messages and updates conversation

**4. Services**
- AuthService: Firebase Auth operations
- FirestoreService: Firestore CRUD and streams
- Routes: Named route constants

## Data Models

### User Model
- Fields: id, name, email
- Methods: toJson(), fromJson(), copyWith()

### Message Model
- Fields: id, conversationId, senderId, text, timestamp, status
- Methods: toJson(), fromJson(), copyWith()

### Conversation Model
- Fields: id, participants[], lastMessage, lastMessageTime
- Methods: toJson(), fromJson(), copyWith()

All models handle null values with defaults and support Firestore Timestamp conversion.

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system.*

### Property 1: Authentication creates session
*For any* valid credentials, successful authentication should store a session token in GetStorage.
**Validates: Requirements 1.3**

### Property 2: Auto-login with valid session
*For any* valid session token, app launch should auto-login and navigate to home.
**Validates: Requirements 1.4**

### Property 3: Conversations ordered by time
*For any* list of conversations, they should be ordered by lastMessageTime descending.
**Validates: Requirements 2.2**

### Property 4: Messages persisted to Firestore
*For any* sent message, it should be added to Firestore and update conversation metadata.
**Validates: Requirements 3.2, 3.3**

### Property 5: Model serialization round-trip
*For any* model, serializing with toJson() then deserializing with fromJson() should produce an equivalent model.
**Validates: Requirements 5.1**

### Property 6: copyWith preserves unchanged fields
*For any* model, calling copyWith() should update specified fields while preserving others.
**Validates: Requirements 5.3**

## Error Handling

### Strategy

- Catch `FirebaseAuthException` and `FirebaseException`
- Display user-friendly messages via `Get.snackbar()`
- Validate input before Firebase calls (email format, password length, empty fields)
- Show loading indicators during async operations

### Validation

- Email: Check format with regex
- Password: Minimum 6 characters
- Messages: Non-empty text

## Testing Strategy

### Approach

Use Dart's `test` package for unit tests. Focus on core functionality.

### Property-Based Testing

Run 100 iterations per property test. Tag format:
```dart
// **Feature: chatzz-messaging-app, Property {number}: {property_text}**
```

Example:
```dart
// **Feature: chatzz-messaging-app, Property 5: Model serialization round-trip**
test('Model serialization round-trip', () {
  for (int i = 0; i < 100; i++) {
    final original = generateRandomUserModel();
    final json = original.toJson();
    final deserialized = UserModel.fromJson(json);
    expect(deserialized, equals(original));
  }
});
```

### Unit Testing

Test categories:
- Model serialization/deserialization
- Controller state management
- Service Firebase integration (with mocks)
- Widget rendering and interaction

### Coverage Goals

- Core business logic: 70%+
- All correctness properties implemented
- Critical user flows tested

