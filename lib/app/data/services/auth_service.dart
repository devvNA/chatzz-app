import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage _storage = GetStorage();

  static const String _sessionKey = 'user_session';

  /// Sign in with email and password
  /// Returns User on success, throws FirebaseAuthException on failure
  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Store session token for auto-login
        await _storage.write(_sessionKey, credential.user!.uid);
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        default:
          message = e.message ?? 'Authentication failed';
      }
      throw FirebaseAuthException(code: e.code, message: message);
    }
  }

  /// Register new user with email and password
  /// Returns User on success, throws FirebaseAuthException on failure
  Future<User?> register(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Store session token for auto-login
        await _storage.write(_sessionKey, credential.user!.uid);
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'An account already exists with this email';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'weak-password':
          message = 'Password is too weak (minimum 6 characters)';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        default:
          message = e.message ?? 'Registration failed';
      }
      throw FirebaseAuthException(code: e.code, message: message);
    }
  }

  /// Sign out current user and clear session
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _storage.remove(_sessionKey);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Sign out failed',
      );
    }
  }

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  /// Get stored session token
  String? get sessionToken => _storage.read(_sessionKey);

  /// Validate session with Firebase
  Future<bool> validateSession() async {
    final token = sessionToken;
    if (token == null) return false;

    try {
      await _auth.currentUser?.reload();
      return _auth.currentUser != null;
    } catch (e) {
      await _storage.remove(_sessionKey);
      return false;
    }
  }
}
