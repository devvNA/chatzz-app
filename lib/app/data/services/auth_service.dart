import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/errors/failures.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage _storage = GetStorage();

  static const String _sessionKey = 'user_session';

  /// Sign in with email and password
  /// Returns Either<AuthFailure, User> - Left for error, Right for success
  Future<Either<AuthFailure, User>> signIn(
    String email,
    String password,
  ) async {
    try {
      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        return Left(
          AuthFailure('Email and password are required', code: 'invalid-input'),
        );
      }

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        log(
          'User ${credential.user!.uid} signed in successfully. Storing session.',
        );
        await _storage.write(_sessionKey, credential.user!.uid);
        return Right(credential.user!);
      } else {
        log('Sign-in successful, but credential.user is null for $email.');
        return Left(AuthFailure('Failed to get user data', code: 'null-user'));
      }
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException during sign-in for $email: Code=${e.code}');
      return Left(AuthFailure.fromFirebaseAuth(e));
    } catch (e) {
      log('Unknown error during sign-in for $email: ${e.toString()}');
      return Left(AuthFailure.unknown(e));
    }
  }

  /// Register new user with email and password
  /// Returns Either<AuthFailure, User> - Left for error, Right for success
  Future<Either<AuthFailure, User>> register(
    String email,
    String password,
  ) async {
    try {
      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        return Left(
          AuthFailure('Email and password are required', code: 'invalid-input'),
        );
      }

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _storage.write(_sessionKey, credential.user!.uid);
        return Right(credential.user!);
      } else {
        return Left(AuthFailure('Failed to create user', code: 'null-user'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure.fromFirebaseAuth(e));
    } catch (e) {
      return Left(AuthFailure.unknown(e));
    }
  }

  /// Sign out current user and clear session
  /// Returns Either<AuthFailure, Unit> - Left for error, Right for success
  Future<Either<AuthFailure, Unit>> signOut() async {
    try {
      await _auth.signOut();
      await _storage.remove(_sessionKey);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure.fromFirebaseAuth(e));
    } catch (e) {
      return Left(
        AuthFailure('Failed to sign out: ${e.toString()}', code: 'unknown'),
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
    try {
      final token = sessionToken;
      if (token == null) return false;

      // Check if current user exists
      if (_auth.currentUser == null) {
        await _storage.remove(_sessionKey);
        return false;
      }

      // Reload user to verify token is still valid
      await _auth.currentUser?.reload();

      // Verify user still exists after reload
      final isValid = _auth.currentUser != null;

      if (!isValid) {
        await _storage.remove(_sessionKey);
      }

      return isValid;
    } catch (e) {
      // Clear invalid session
      await _storage.remove(_sessionKey);
      return false;
    }
  }
}
