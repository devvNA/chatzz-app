# Implementation Plan - Chatzz Messaging App

- [x] 1. Set up project structure
  - Configure Firebase in main.dart
  - Initialize GetStorage
  - Set up GetX routing (app_routes.dart, app_pages.dart)
  - Create folder structure (modules, data, core)
  - _Requirements: All_

- [x] 2. Implement data models



  - [x] 2.1 Create User, Message, and Conversation models
    - Implement toJson, fromJson, copyWith methods
    - Handle null values with defaults
    - Support Firestore Timestamp conversion
    - _Requirements: 5.1, 5.2, 5.3_

  - [ ]* 2.2 Write property test for model serialization
    - **Property 5: Model serialization round-trip**
    - **Validates: Requirements 5.1**
  - [ ]* 2.3 Write property test for copyWith
    - **Property 6: copyWith preserves unchanged fields**
    - **Validates: Requirements 5.3**

- [x] 3. Implement Firebase services
  - [x] 3.1 Create AuthService
    - Implement signIn, register, signOut methods
    - Handle FirebaseAuthException
    - _Requirements: 1.1, 1.2, 1.5_
  - [x] 3.2 Create FirestoreService
    - Implement getConversations stream
    - Implement getMessages stream
    - Implement sendMessage method
    - Implement createConversation method
    - Implement updateConversation method
    - _Requirements: 2.1, 3.1, 3.2, 3.3, 4.2, 4.3_

- [x] 4. Implement authentication module
  - [x] 4.1 Create LoginView and LoginController
    - Build email/password form with validation
    - Handle login with AuthService
    - Save session to GetStorage on success
    - Navigate to home on success
    - Display errors via Get.snackbar
    - _Requirements: 1.2, 1.3_
  - [ ]* 4.2 Write property test for authentication
    - **Property 1: Authentication creates session**
    - **Validates: Requirements 1.3**

  - [x] 4.3 Create RegisterView and RegisterController
    - Build registration form
    - Create user in Firebase Auth
    - Create User document in Firestore
    - _Requirements: 1.1_
  - [x] 4.4 Create SplashView and SplashController
    - Check GetStorage for session token
    - Validate with Firebase Auth
    - Navigate to home or login
    - _Requirements: 1.4, 1.5_
  
  - [ ]* 4.5 Write property test for auto-login
    - **Property 2: Auto-login with valid session**
    - **Validates: Requirements 1.4**


- [x] 5. Checkpoint - Ensure authentication works



  - Ensure all tests pass, ask the user if questions arise.
- [x] 6. Implement home screen
  - [x] 6.1 Create HomeView and HomeController

    - Display conversation list from Firestore stream
    - Order by lastMessageTime descending
    - Show contact name, last message, timestamp
    - Add FloatingActionButton for new chat
    - _Requirements: 2.1, 2.2, 2.3, 2.4_
  
  - [ ]* 6.2 Write property test for conversation ordering
    - **Property 3: Conversations ordered by time**
    - **Validates: Requirements 2.2**
  

  - [x] 6.3 Create user list for new conversations

    - Display all users from Firestore
    - Check if conversation exists
    - Create new conversation if needed
    - Navigate to chat screen
    - _Requirements: 4.1, 4.2, 4.3, 4.4_
-

- [x] 7. Implement chat screen
  - [x] 7.1 Create ChatView and ChatController

    - Stream messages from Firestore
    - Display messages with MessageBubble widget
    - Align outgoing right, incoming left
    - Different backgrounds for outgoing/incoming
    - _Requirements: 3.1, 3.4, 3.5_
  - [x] 7.2 Implement message sending
  - [x] 7.2 Implement message sending
    - Create Message Model with UUID
    - Add to Firestore
    - Update conversation metadata
    - Prevent empty messages
    - _Requirements: 3.2, 3.3_
  
  - [ ]* 7.3 Write property test for message persistence
    - **Property 4: Messages persisted to Firestore**
    - **Validates: Requirements 3.2, 3.3**

- [x] 8. Checkpoint - Ensure messaging works
- [x] 9. Add error handling and validationquestions arise.




  - Add try-catch blocks to all async operations
  - Validate email format and password length
  - Display errors via Get.snackbar
  - _Requirements: All_
- [x] 10. Polish and finalize

  - Test all user flows
  - Verify Firebase integration
  - Check UI consistency
  - _Requirements: All_
