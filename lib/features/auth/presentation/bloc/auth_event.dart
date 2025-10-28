import 'package:equatable/equatable.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../../../core/usecases/usecase.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginWithPasswordEvent extends AuthEvent {
  final LoginParams params;
  LoginWithPasswordEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class SendOtpEvent extends AuthEvent {
  final PhoneParams params;
  SendOtpEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class VerifyOtpEvent extends AuthEvent {
  final VerifyOtpParams params;
  VerifyOtpEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class LogoutEvent extends AuthEvent {
  final NoParams params = const NoParams();
}

class CheckCachedUserEvent extends AuthEvent {}

class CheckPhoneNumberEvent extends AuthEvent {
  final PhoneParams params;
  CheckPhoneNumberEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class SignUpEvent extends AuthEvent {
  final SignUpParams params;
  SignUpEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateProfileEvent extends AuthEvent {
  final UpdateProfileParams params;
  UpdateProfileEvent(this.params);

  @override
  List<Object?> get props => [params];
}