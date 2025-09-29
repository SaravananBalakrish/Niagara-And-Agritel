import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/api_urls.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterDetailsModel> loginWithPassword(String phone, String password);
  Future<String> sendOtp(String phone);
  Future<void> logout();
  Future<RegisterDetailsModel> verifyOtp(String verificationId, String otp, String countryCode);
  Future<bool> checkPhoneNumber(String phone, String countryCode);
}

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
  Future<RegisterDetailsModel> loginWithPassword(String phone, String password) async {
    try {
      String mobileNumber = phone;
      if (phone.startsWith('+')) {
        mobileNumber = phone.substring(phone.length - 10);
      }

      // Fetch device token and IP address
      String deviceToken = '';
      String ipAddress = '';
      try {
        deviceToken = await FirebaseMessaging.instance.getToken() ?? '';
        ipAddress = '';
        print('Device token: $deviceToken, IP address: $ipAddress');
      } catch (e) {
        print('Error fetching device info: $e');
      }

      final response = await apiClient.post(ApiUrls.loginWithPasswordUrl, body: {
        'mobileNumber': mobileNumber,
        'password': password,
        'deviceToken': deviceToken,
        'macAddress': ipAddress,
      });
      print('Login API response: $response');
      if (response['code'] == 200) {
        return RegisterDetailsModel.fromJson(response['data']);
      } else {
        throw AuthException(
          statusCode: response['code'].toString(),
          message: response['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      print('Login error: $e');
      throw AuthException(
        statusCode: 'login-failed',
        message: 'Login failed: $e',
      );
    }
  }

  @override
  Future<String> sendOtp(String phone) async {
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
  Future<RegisterDetailsModel> verifyOtp(String verificationId, String otp, String countryCode) async {
    try {
      PhoneAuthCredential credential;
      if (kIsWeb) {
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

      final idToken = await firebaseUser.getIdToken();

      // Fetch device token and IP address
      String deviceToken = '';
      String ipAddress = '';
      try {
        deviceToken = await FirebaseMessaging.instance.getToken() ?? '';
        ipAddress = '';
        print('Device token: $deviceToken, IP address: $ipAddress');
      } catch (e) {
        print('Error fetching device info: $e');
      }

      final mobileNumber = firebaseUser.phoneNumber!.substring(countryCode.length);

      final response = await apiClient.post(
        ApiUrls.loginWithOtpUrl,
        headers: {'Authorization': 'Bearer $idToken'},
        body: {
          'mobileNumber': mobileNumber,
          'password': '',
          'deviceToken': deviceToken,
          'macAddress': ipAddress,
        },
      );
      print('OTP Login API response: $response');
      if (response['code'] == 200) {
        return RegisterDetailsModel.fromFirebaseUser(firebaseUser, response['data']);
      } else {
        throw AuthException(
          statusCode: response['code'].toString(),
          message: response['message'] ?? 'OTP verification failed',
        );
      }
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
    } catch (e, stacktrace) {
      print('Verify OTP error: $e');
      print('Verify OTP stacktrace: $stacktrace');
      throw AuthException(
        statusCode: 'unknown',
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  @override
  Future<bool> checkPhoneNumber(String phone, String countryCode) async {
    Map<String, dynamic> body = {
      'mobileNumber': phone,
      'countryCode': countryCode.substring(1),
    };
    try {
      final response = await apiClient.post(ApiUrls.verifyUserUrl, body: body);
      print("body :: $body");
      print("response :: $response");
      return response['code'] == 200;
    } catch (e) {
      print('Check phone number error: $e');
      throw AuthException(
        statusCode: 'check-phone-failed',
        message: 'Failed to check phone number: $e',
      );
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}