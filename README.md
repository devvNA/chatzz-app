<p align="center">
  <img src="assets/images/logo.png" alt="Chatzz Logo" width="120" height="120">
</p>

<h1 align="center">Chatzz</h1>

<p align="center">
  <strong>Connect Instantly. Chat Beautifully.</strong>
</p>

<p align="center">
  A modern, elegant instant messaging app built with Flutter & Firebase
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#tech-stack">Tech Stack</a> •
  <a href="#getting-started">Getting Started</a> •
  <a href="#architecture">Architecture</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase">
  <img src="https://img.shields.io/badge/GetX-8B5CF6?style=for-the-badge&logo=getx&logoColor=white" alt="GetX">
</p>

---

## ✨ Overview

**Chatzz** is a beautifully crafted real-time messaging application that combines stunning UI design with powerful functionality. Built with Flutter for cross-platform excellence and Firebase for reliable backend services, Chatzz delivers a premium chat experience with attention to every detail.

> 🎨 *"Not just another chat app — a carefully designed communication experience."*

---

## 🚀 Features

### 💬 **Messaging**
- Real-time message delivery with Firebase
- Message status indicators (sent, delivered, read)
- Smart conversation list with last message preview
- Time separators for better message organization

### 🔍 **Search & Discovery**
- Real-time search with debounce optimization
- Filter conversations (All, Unread, Recent)
- Alphabetically grouped contact list
- Highlighted search results

### 👤 **Profile & Contacts**
- Beautiful user profiles with hero animations
- Online/offline status indicators
- Contact management with quick actions
- Block and report functionality

### 🎨 **Design Excellence**
- Elegant dark/light theme support
- Animated splash screen with floating particles
- Glass-morphism UI elements
- Smooth staggered animations throughout

### 🔐 **Authentication**
- Secure email/password authentication
- Session persistence with auto-login
- Clean login/register flow with validation

---

## 📱 Screenshots

<p align="center">
  <img src="docs/screenshots/splash.png" width="200" alt="Splash Screen">
  <img src="docs/screenshots/login.png" width="200" alt="Login">
  <img src="docs/screenshots/home.png" width="200" alt="Home">
  <img src="docs/screenshots/chat.png" width="200" alt="Chat">
</p>

<p align="center">
  <img src="docs/screenshots/contacts.png" width="200" alt="Contacts">
  <img src="docs/screenshots/profile.png" width="200" alt="Profile">
  <img src="docs/screenshots/settings.png" width="200" alt="Settings">
  <img src="docs/screenshots/dark-mode.png" width="200" alt="Dark Mode">
</p>

---

## 🛠 Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.10+ |
| **Language** | Dart 3.0+ |
| **State Management** | GetX |
| **Backend** | Firebase (Auth, Firestore, Storage) |
| **Local Storage** | GetStorage |
| **Architecture** | Clean Architecture + MVC |

### Key Packages

```yaml
dependencies:
  get: ^4.6.6                    # State management & navigation
  firebase_core: ^3.6.0          # Firebase core
  firebase_auth: ^5.3.1          # Authentication
  cloud_firestore: ^5.4.4        # Real-time database
  get_storage: ^2.1.1            # Local persistence
  cached_network_image: ^3.4.1   # Image caching
  google_fonts: ^6.2.1           # Typography
  uuid: ^4.5.1                   # Unique identifiers
```

---

## 🏗 Architecture

Chatzz follows **Clean Architecture** principles with **GetX MVC pattern**:

```
lib/
├── main.dart
└── app/
    ├── core/
    │   ├── theme/           # App colors, themes, dark mode
    │   ├── utils/           # Validators, error handlers
    │   └── widgets/         # Reusable components
    ├── data/
    │   ├── models/          # Data models (User, Message, Conversation)
    │   └── services/        # Firebase services (Auth, Firestore)
    ├── modules/
    │   ├── splash/          # Animated splash screen
    │   ├── auth/            # Login & Register
    │   ├── base/            # Main layout with bottom nav
    │   ├── home/            # Conversations list
    │   ├── chat/            # Chat detail view
    │   ├── contacts/        # Contacts management
    │   ├── profile/         # User profile view
    │   └── settings/        # App settings & preferences
    └── routes/              # Navigation routes
```

---

## 🚦 Getting Started

### Prerequisites

- Flutter SDK 3.10 or higher
- Dart 3.0 or higher
- Firebase project with enabled services
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/devvNA/chatzz.git
   cd chatzz
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**

   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Enable Authentication (Email/Password)
   - Enable Cloud Firestore
   - Download config files:
     - `google-services.json` → `android/app/`
     - `GoogleService-Info.plist` → `ios/Runner/`

4. **Run the app**
   ```bash
   flutter run
   ```

### Firebase Collections Structure

```
users/
  {userId}/
    - id, name, email, photoUrl, createdAt

conversations/
  {conversationId}/
    - id, participants[], lastMessage, lastMessageTime

messages/
  {messageId}/
    - id, conversationId, senderId, text, timestamp, status
```

---

## 🎨 Design System

### Colors

| Color | Light Mode | Dark Mode |
|-------|------------|-----------|
| Primary | `#00D09C` | `#00E5AD` |
| Background | `#FFFFFF` | `#0D0D14` |
| Surface | `#FFFFFF` | `#1A1A2E` |
| Text Primary | `#2D3748` | `#F7FAFC` |

### Typography

- **Font Family**: Poppins (Google Fonts)
- **Heading**: Bold, 20-28sp
- **Body**: Regular/Medium, 14-16sp
- **Caption**: Regular, 12sp

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


---

<p align="center">
  Made with ❤️ and Flutter
</p>

<p align="center">
  <a href="#chatzz">Back to top ↑</a>
</p>
