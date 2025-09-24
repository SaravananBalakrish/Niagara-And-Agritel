import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithPassword(String phone, String password);
  Future<String> sendOtp(String phone);
  Future<void> logout();
  Future<UserModel> verifyOtp(String verificationId, String otp);
}

// Helper class to hold the verification ID and confirmation (for cross-platform handling)
class OtpVerificationResult {
  final String? verificationId;
  final ConfirmationResult? confirmationResult;

  OtpVerificationResult({this.verificationId, this.confirmationResult});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> loginWithPassword(String mobileNumber, String password) async {
    final response = await apiClient.post(ApiUrls.loginUrl, body: {
      'mobile': mobileNumber,
      'password': password,
    });
    return UserModel.fromJson(response);
  }

  @override
  Future<String> sendOtp(String phone) async {
    if (!phone.startsWith('+')) {
      phone = '+91$phone';
    }
    try {
      await _firebaseAuth.setLanguageCode('en');
      if (kIsWeb) {
        final confirmationResult = await _firebaseAuth.signInWithPhoneNumber(phone);
        print('Web: OTP sent, verificationId=${confirmationResult.verificationId}');
        return confirmationResult.verificationId;
      } else {
        final completer = Completer<String>();
        await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            try {
              await _firebaseAuth.signInWithCredential(credential);
            } catch (e) {
              print('Auto-verification failed: $e');
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            print('Verification failed: ${e.code}, ${e.message}');
            completer.completeError(AuthException(statusCode: e.code, message: e.message ?? 'Failed to send OTP'));
          },
          codeSent: (String verificationId, int? resendToken) {
            print('OTP sent: verificationId=$verificationId');
            if (!completer.isCompleted) completer.complete(verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print('Code auto-retrieval timeout: verificationId=$verificationId');
            if (!completer.isCompleted) completer.complete(verificationId);
          },
        );
        return await completer.future;
      }
    } catch (e) {
      print('Send OTP error: $e');
      throw AuthException(statusCode: 'unknown', message: 'Failed to send OTP: $e');
    }
  }

  @override
  Future<UserModel> verifyOtp(String verificationId, String otp) async {
    try {
      PhoneAuthCredential credential;
      if (kIsWeb) {
        // Handle web-specific verification if needed (e.g., using confirmationResult.confirm)
        throw AuthException(
          statusCode: 'platform-error',
          message: 'Web OTP verification is not supported in this implementation.',
        );
      } else {
        credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      }
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw AuthException(
          statusCode: 'null-user',
          message: 'User is null after OTP verification. Please try again.',
        );
      }
      return UserModel.fromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-verification-code':
          message = 'The OTP entered is invalid. Please try again.';
          break;
        case 'invalid-verification-id':
          message = 'Invalid verification ID. Please request a new OTP.';
          break;
        case 'session-expired':
          message = 'The OTP session has expired. Please request a new OTP.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please wait a few minutes and try again.';
          break;
        case 'billing-not-enabled':
          message = 'Billing is not enabled for this project. Please contact support.';
          break;
        default:
          message = 'Authentication failed: ${e.message ?? "An error occurred."}';
      }
      throw AuthException(statusCode: e.code, message: message);
    } on FirebaseException catch (e) {
      if (e.code == 'app-check-token-error' || e.message?.contains('App attestation failed') == true) {
        throw AuthException(
          statusCode: 'app-check-failed',
          message: 'App verification failed. Please ensure your app is properly configured.',
        );
      }
      throw AuthException(
        statusCode: e.code,
        message: 'Firebase error: ${e.message ?? "An unknown error occurred."}',
      );
    } catch (e) {
      print('Verify OTP error: $e');
      throw AuthException(
        statusCode: 'unknown',
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  @override
  Future<void> logout() async {
    // Modified: Use Firebase signOut (in addition to your API if needed)
    await _firebaseAuth.signOut();
    // Optionally call your API logout if it has server-side session cleanup
    // await apiClient.post('/auth/logout');
  }
}