import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart' as di;
import '../../../../core/error/failures.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithPassword loginWithPassword;
  final SendOtp sendOtp;
  final VerifyOtp verifyOtp;
  final Logout logout;
  final CheckPhoneNumber checkPhoneNumber;
  final SignUp signUp;
  final UpdateProfile updateProfile;
  final NotificationService _notificationService = di.sl<NotificationService>();

  AuthBloc({
    required this.loginWithPassword,
    required this.sendOtp,
    required this.verifyOtp,
    required this.logout,
    required this.checkPhoneNumber,
    required this.signUp,
    required this.updateProfile,
  }) : super(AuthInitial()) {

    on<LoginWithPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await loginWithPassword(event.params);
      result.fold(
        (failure) => emit(failure is AuthFailure
            ? AuthError(message: failure.message, code: failure.code)
            : AuthError(message: failure.message)),
        (authData) {
          emit(Authenticated(authData));
          // Remove: _dashboardBloc.add(FetchDashboardGroupsEvent(authData.userDetails.id));
          _notificationService.showNotification(
            title: 'Login Successful',
            body: 'Welcome back, ${authData.userDetails.name}!',
            payload: 'login_success',
          );
        },
      );
    });

    on<SendOtpEvent>((event, emit) async {
      print('Processing SendOtpEvent: phone=${event.params.phone}');
      emit(AuthLoading());
      final result = await sendOtp(event.params);
      result.fold(
            (failure) {
          print('SendOtpEvent failed: $failure');
          emit(failure is AuthFailure
              ? AuthError(message: failure.message, code: failure.code)
              : AuthError(message: failure.message));
          if (failure is AuthFailure && failure.code == 'too-many-requests') {
            _notificationService.showNotification(
              title: 'Too Many Attempts',
              body: 'Please wait a few minutes before trying again.',
              payload: 'too_many_requests',
            );
          }
        },
            (verificationId) {
          emit(OtpSent(
            verificationId: verificationId,
            phone: event.params.phone,
            countryCode: event.params.countryCode,
          ));
          _notificationService.showNotification(
            title: 'OTP Sent',
            body: 'An OTP has been sent to ${event.params.phone}',
            payload: 'otp_sent',
          );
        },
      );
    });

    // Similar changes for VerifyOtpEvent:
    on<VerifyOtpEvent>((event, emit) async {
      print('Processing VerifyOtpEvent: verificationId=${event.params.verificationId}, otp=${event.params.otp}');
      emit(AuthLoading());
      final result = await verifyOtp(event.params);
      result.fold(
        (failure) {
          print('VerifyOtpEvent failed: $failure');
          emit(failure is AuthFailure
              ? AuthError(message: failure.message, code: failure.code)
              : AuthError(message: failure.message));
          if (failure is AuthFailure && failure.code == 'invalid-verification-code') {
            _notificationService.showNotification(
              title: 'Invalid OTP',
              body: 'The OTP entered is invalid. Please try again.',
              payload: 'invalid_otp',
            );
          }
        },
        (authData) {
          emit(Authenticated(authData));
          // Remove: _dashboardBloc.add(FetchDashboardGroupsEvent(authData.userDetails.id));
          _notificationService.showNotification(
            title: 'OTP Verified',
            body: 'Welcome, ${authData.userDetails.name}! You are now logged in.',
            payload: 'otp_verified',
          );
        },
      );
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await logout(event.params);
      result.fold(
        (failure) => emit(failure is AuthFailure
            ? AuthError(message: failure.message, code: failure.code)
            : AuthError(message: failure.message)),
        (_) {
          emit(LoggedOut());
          _notificationService.showNotification(
            title: 'Logged Out',
            body: 'You have been logged out successfully.',
            payload: 'logout',
          );
        },
      );
    });

    on<CheckCachedUserEvent>((event, emit) async {
      final localDataSource = di.sl<AuthLocalDataSource>();
      final cachedAuthData = await localDataSource.getCachedAuthData();
      if (cachedAuthData != null) {
        emit(Authenticated(cachedAuthData));
       /* _notificationService.showNotification(
          title: 'Auto-Login',
          body: 'Welcome back, ${cachedAuthData.userDetails.name}!',
          payload: 'auto_login',
        );*/
      } else {
        emit(AuthInitial());
      }
    });

    on<CheckPhoneNumberEvent>((event, emit) async {
      print('Processing CheckPhoneNumberEvent: phone=${event.params.phone}');
      emit(AuthLoading());
      final result = await checkPhoneNumber(event.params);
      result.fold(
        (failure) {
          print('CheckPhoneNumberEvent failed: $failure');
          emit(failure is AuthFailure
              ? AuthError(message: failure.message, code: failure.code)
              : AuthError(message: failure.message));
          _notificationService.showNotification(
            title: 'Error',
            body: failure.message,
            payload: 'check_phone_error',
          );
        },
        (exists) {
          emit(PhoneNumberChecked(exists: exists, phone: event.params.phone, countryCode: event.params.countryCode));
          _notificationService.showNotification(
            title: exists ? 'Phone Number Found' : 'Phone Number Not Found',
            body: exists
                ? 'Phone number ${event.params.phone} is registered.'
                : 'Phone number ${event.params.phone} is not registered.',
            payload: 'check_phone_result',
          );
        },
      );
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await signUp(event.params);
      result.fold(
            (failure) => emit(failure is AuthFailure
            ? AuthError(message: failure.message, code: failure.code)
            : AuthError(message: failure.message)),
            (authData) {
          emit(Authenticated(authData));
          _notificationService.showNotification(
            title: 'Sign Up Successful',
            body: 'Welcome, ${authData.userDetails.name}!',
            payload: 'signup_success',
          );
        },
      );
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await updateProfile(event.params);
      result.fold(
            (failure) => emit(failure is AuthFailure
            ? AuthError(message: failure.message, code: failure.code)
            : AuthError(message: failure.message)),
            (authData) {
          emit(Authenticated(authData)); // Re-emit updated auth state
          _notificationService.showNotification(
            title: 'Profile Updated',
            body: 'Your profile has been updated successfully.',
            payload: 'profile_updated',
          );
        },
      );
    });
  }
}