import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Login event (OTP or password)
class LoginEvent extends AuthEvent {
  final String mobileNumber;
  final String? otp;
  final String? password;

  const LoginEvent({required this.mobileNumber, this.otp, this.password});

  @override
  List<Object?> get props => [mobileNumber, otp ?? '', password ?? ''];
}

// Logout event
class LogoutEvent extends AuthEvent {}
