import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class OtpSent extends AuthState {
  final String verificationId;
  final String phone;
  final String countryCode;

  OtpSent({required this.verificationId, required this.phone, required this.countryCode});

  @override
  List<Object?> get props => [verificationId, phone];
}

class OtpVerified extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final String? code; // Added to capture specific error codes

  AuthError({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class LoggedOut extends AuthState {}

class PhoneNumberChecked extends AuthState {
  final bool exists;
  final String phone;
  final String countryCode;

  PhoneNumberChecked({required this.exists, required this.phone, required this.countryCode});

  @override
  List<Object?> get props => [exists, phone];
}