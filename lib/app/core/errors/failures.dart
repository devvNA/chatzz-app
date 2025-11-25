import 'package:firebase_auth/firebase_auth.dart';

/// Base failure class for all errors
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => message;
}

/// Authentication related failures
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});

  factory AuthFailure.fromFirebaseAuth(FirebaseAuthException e) {
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
      case 'invalid-credential':
        message = 'Invalid email or password';
        break;
      case 'email-already-in-use':
        message = 'An account already exists with this email';
        break;
      case 'weak-password':
        message = 'Password is too weak (minimum 6 characters)';
        break;
      case 'too-many-requests':
        message = 'Too many failed attempts. Please try again later';
        break;
      case 'network-request-failed':
        message = 'Network error. Please check your connection';
        break;
      case 'operation-not-allowed':
        message = 'This operation is not allowed';
        break;
      case 'invalid-input':
        message = e.message ?? 'Invalid input provided';
        break;
      default:
        message = e.message ?? 'Authentication failed';
    }
    return AuthFailure(message, code: e.code);
  }

  factory AuthFailure.unknown(dynamic e) {
    return AuthFailure(
      'An unexpected error occurred: ${e.toString()}',
      code: 'unknown',
    );
  }
}

/// Server/Network related failures
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// Validation related failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}
