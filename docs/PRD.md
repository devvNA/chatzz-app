# Product Requirement Document (PRD)
**Project Name:** Chatzz
**Version:** 1.0.0
**Status:** Initial Draft
**Date:** 22 November 2025

## 1. Executive Summary
**Chatzz** adalah aplikasi *instant messaging* sederhana berbasis mobile (Android & iOS) yang mengutamakan kecepatan, efisiensi, dan desain antarmuka yang bersih (*Clean UI*). Aplikasi ini bertujuan menyediakan platform komunikasi *real-time* yang ringan namun kaya fitur esensial seperti pesan teks, gambar, dan status pengiriman, dengan arsitektur yang siap untuk skalabilitas masa depan.

## 2. Target Audience
*   Pengguna yang menginginkan aplikasi chat minimalis tanpa fitur "bloatware".
*   Developer/Stakeholder yang membutuhkan *baseline* aplikasi chat modern dengan *Clean Architecture* untuk dikembangkan lebih lanjut.

## 3. Core Features (MVP)

### 3.1 Authentication Module
*   **Register:** Pengguna baru dapat mendaftar menggunakan Email & Password, serta melengkapi profil (Nama Lengkap, Phone).
*   **Login:** Autentikasi aman menggunakan Firebase Auth.
*   **Auto-Login:** Sesi pengguna disimpan lokal (`GetStorage`) untuk login otomatis saat aplikasi dibuka kembali.

### 3.2 Home Screen (Chat List)
*   **Header:** Menampilkan judul aplikasi, dan tombol "New Chat".
*   **Search & Filter**
*   **Conversation List:** Daftar riwayat percakapan yang diurutkan berdasarkan waktu pesan terakhir.
    *   Menampilkan avatar (placeholder/inisial), nama kontak (bold), *preview* pesan terakhir (truncated), dan timestamp.
*   **Floating Action Button (FAB):** Akses cepat untuk memulai pesan baru ke pengguna yang terdaftar di sistem.

### 3.3 Chat Detail Screen
*   **Header:** Menampilkan nama kontak, avatar, dan tombol *Back*.
*   **Message Bubble:**
    *   **Outgoing (User):** Rata kanan, background Hijau, teks Putih/Hitam.
    *   **Incoming (Contact):** Rata kiri, background Abu-abu terang, teks Hitam.
*   **Message Status:** Indikator status pesan (Sending, Sent, Read).
*   **Input Area:** Sticky di bagian bawah; input teks + tombol kirim + opsi lampiran gambar.
*   **Multimedia:** Mendukung pengiriman gambar (kamera/galeri).

### 3.4 Global Features
*   **Connectivity Check:** Pemantauan status internet secara *real-time* (Global Snackbar/Toast jika offline).
*   **Local Database:** Caching pesan untuk akses offline (*Offline-first experience*).

## 4. Technical Specifications

### 4.1 Architecture
*   **Pattern:** GetX Pattern (Model-View-Controller) + Clean Architecture principles.
*   **Model Classes:** Data Models there must be : Generate toJson method, Generate copyWith method, and Use default value.
*   **State Management:** GetX (Reactive State Manager).
*   **Dependency Injection:** GetX Bindings.
*   **Navigation:** GetX Named Routes.

### 4.2 Tech Stack
*   **Framework:** Flutter (Latest Stable).
*   **Language:** Dart.
*   **Backend (BaaS):** Firebase
    *   **Auth:** Email/Password Authentication.
    *   **Firestore:** NoSQL Database untuk data user & chat realtime.
    *   **Storage:** Menyimpan media (foto profil, gambar chat).
*   **Local Storage:** `Isar Database` (Session & Message Caching).

### 4.3 Key Libraries
*   `get`: State management & routing.
*   `firebase_core`, `cloud_firestore`, `firebase_auth`: Backend integration.
*   `connectivity_plus`: Network monitoring.
*   `image_picker`: Media selection.
*   `intl`: Date/time formatting.

## 5. UI/UX Guidelines
*Referensi desain lengkap tersedia di folder: `docs/design/`*

### 5.1 Color Palette (Chatzz App Theme)

*   **Primary Color:** `#00D09C` → Teal Green (brand color utama)
*   **Primary Dark:** `#00B089` → Untuk state pressed / hover
*   **Accent Color:** `#48BB78` → Online indicator & elemen positif
*   **Background:** `#F5FAF8` → Latar belakang utama (sangat soft mint)
*   **Surface / Card:** `#FFFFFF` → Card, app bar, bubble chat sendiri
*   **Gradient Start:** `#E0F7F2` → Splash screen & background halus atas
*   **Gradient End:** `#C8F0E8` → Splash screen & background halus bawah

*   **Message Bubbles:**
    *   Incoming (orang lain): `#E8F5F3` → Soft mint (bukan abu-abu seperti WhatsApp)
    *   Outgoing (kita sendiri): `#FFFFFF` → Putih bersih dengan border tipis mint (sesuai desain)

*   **Text Colors:**
    *   Primary Text: `#2D3748` → Dark slate (bukan hitam pekat, lebih soft & modern)
    *   Secondary Text: `#718096` → Abu-abu sedang (timestamp, hint, subtitle)
    *   On Primary: `#FFFFFF` → Teks putih di atas background `#00D09C`

*   **Status & Icons:**
    *   Online Dot: `#48BB78`
    *   Bottom Nav Active: `#00D09C`
    *   Bottom Nav Inactive: `#A0AEC0`

### 5.2 Typography
*   **Font Family:** Roboto (Android) / San Francisco (iOS) - Material Design Standard
*   **Text Styles:**
    *   App Title: 20-24sp, Bold/SemiBold
    *   Screen Title: 18-20sp, SemiBold
    *   Contact Name: 16sp, SemiBold
    *   Message Text: 14-16sp, Regular
    *   Timestamp: 12sp, Regular
    *   Button Text: 14-16sp, Medium

### 5.3 Screen-Specific Guidelines

#### 5.3.1 Splash Screen / Auto-Login
*Referensi: `docs/design/auto-login_splash_screen/screen.png`*
*   Centered app logo/branding
*   Loading indicator di bawah logo
*   Background gradient atau solid color (Primary/Secondary)
*   Minimal text, fokus pada visual identity

#### 5.3.2 Login & Register Screen
*Referensi: `docs/design/login_/_register_screen/screen.png`*
*   Clean form layout dengan spacing konsisten (16-24dp)
*   Input fields dengan border radius 8-12dp
*   Primary button dengan full-width atau near full-width
*   Clear visual hierarchy (Title → Form → Action Button)
*   Link/Text button untuk navigasi antar auth screens
*   Error messages di bawah input field yang relevan

#### 5.3.3 Home Screen (Chat List)
*Referensi: `docs/design/home_-_chat_list_screen/screen.png`*
*   **AppBar:**
    *   Title "Chatzz" atau "Messages" di kiri
    *   Search icon & Menu/Profile icon di kanan
    *   Elevation minimal (0-2dp) untuk flat design
*   **Chat List Item:**
    *   Avatar (48-56dp) di kiri dengan border radius 50%
    *   Contact name (Bold, 16sp) di atas
    *   Last message preview (Regular, 14sp, max 2 lines, ellipsis)
    *   Timestamp (12sp, gray) di kanan atas
    *   Unread badge (circular, primary color) jika ada pesan baru
    *   Divider atau spacing 8-12dp antar item
*   **FAB:** Circular, primary color, icon "add" atau "edit", positioned bottom-right dengan margin 16dp

#### 5.3.4 Chat Detail Screen
*Referensi: `docs/design/chat_detail_screen/screen.png`*
*   **AppBar:**
    *   Back button di kiri
    *   Avatar + Contact name di tengah/kiri-tengah
    *   Action icons (call, video, menu) di kanan
*   **Message Bubbles:**
    *   Border radius: 12-16dp (rounded corners)
    *   Padding: 12dp horizontal, 8-10dp vertical
    *   Max width: 70-80% dari screen width
    *   Tail/pointer optional (untuk aesthetic)
    *   Timestamp di dalam atau di bawah bubble (8-10sp)
    *   Status indicator (✓, ✓✓, ✓✓ blue) untuk outgoing messages
*   **Input Area:**
    *   Sticky bottom dengan elevation 4-8dp
    *   Rounded text field dengan border radius 24dp
    *   Attachment icon (camera/gallery) di kiri
    *   Send button (icon atau text) di kanan
    *   Background: white atau light gray

#### 5.3.5 User Profile Screen
*Referensi: `docs/design/user_profile_screen/screen.png`*
*   **Header Section:**
    *   Large avatar (80-120dp) centered atau di atas
    *   Edit icon overlay pada avatar
    *   Name & status/bio di bawah avatar
*   **Info Section:**
    *   List items dengan icon + label + value
    *   Dividers antar sections
    *   Edit buttons atau navigasi ke edit screen
*   **Action Buttons:**
    *   Logout button dengan destructive color (red)
    *   Clear spacing dari content lain

### 5.4 Component Standards
*   **Buttons:**
    *   Primary: Filled, primary color, white text, border radius 8-12dp
    *   Secondary: Outlined, primary color border, primary color text
    *   Text: No background, primary color text
    *   Height: 48-56dp untuk touch target
*   **Input Fields:**
    *   Border radius: 8-12dp
    *   Padding: 16dp horizontal, 12-16dp vertical
    *   Border: 1dp solid gray (unfocused), 2dp primary color (focused)
    *   Label: Floating atau fixed di atas field
*   **Cards/Containers:**
    *   Border radius: 8-16dp
    *   Elevation: 0-4dp (prefer flat design)
    *   Padding: 16dp
    *   Margin: 8-16dp
*   **Icons:**
    *   Size: 24dp (standard), 20dp (small), 32dp (large)
    *   Color: Inherit dari context atau primary/secondary

### 5.5 Spacing & Layout
*   **Base Unit:** 8dp (semua spacing kelipatan 8)
*   **Screen Padding:** 16dp horizontal
*   **Section Spacing:** 24-32dp vertical
*   **Element Spacing:** 8-16dp
*   **Safe Area:** Respect system insets (notch, navigation bar)

### 5.6 Responsiveness
*   Menggunakan `MediaQuery` atau `Get.width` / `Get.height` untuk adaptasi layar
*   Breakpoints untuk tablet: width > 600dp
*   Flexible layouts dengan `Expanded`, `Flexible`, `LayoutBuilder`
*   Test pada berbagai screen sizes (small, medium, large, tablet)

<!-- ## 6. Future Roadmap (Phase 2)
*   Push Notifications (FCM).
*   Group Chat.
*   Voice Note & Video Call (WebRTC/Agora).
*   End-to-End Encryption.
*   Search & Filter. -->



***
*Last Updated: 22 Nov 2025*