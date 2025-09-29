import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithPassword extends UseCase<RegisterDetailsEntity, LoginParams> {
  final AuthRepository repository;
  LoginWithPassword(this.repository);

  @override
  Future<Either<Failure, RegisterDetailsEntity>> call(LoginParams params) {
    return repository.loginWithPassword(params.phone, params.password);
  }
}

class LoginParams extends Equatable {
  final String phone;
  final String password;
  const LoginParams({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}

class SendOtp extends UseCase<String, PhoneParams> {
  final AuthRepository repository;
  SendOtp(this.repository);

  @override
  Future<Either<Failure, String>> call(PhoneParams params) {
    final fullPhone = params.phone.startsWith('+') ? params.phone : params.countryCode + params.phone;
    return repository.sendOtp(fullPhone);
  }
}

class PhoneParams extends Equatable {
  final String phone;
  final String countryCode;
  const PhoneParams(this.phone, this.countryCode);

  @override
  List<Object?> get props => [phone, countryCode];
}

class VerifyOtp extends UseCase<RegisterDetailsEntity, VerifyOtpParams> {
  final AuthRepository repository;
  VerifyOtp(this.repository);

  @override
  Future<Either<Failure, RegisterDetailsEntity>> call(VerifyOtpParams params) {
    return repository.verifyOtp(params.verificationId, params.otp, params.countryCode);
  }
}

class VerifyOtpParams extends Equatable {
  final String verificationId;
  final String otp;
  final String countryCode;

  const VerifyOtpParams({required this.verificationId, required this.otp, required this.countryCode});
  @override
  List<Object?> get props => [verificationId, otp, countryCode];
}

/// Logout use case
class Logout extends UseCase<void, NoParams> {
  final AuthRepository repository;
  Logout(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}

/// Check Phone Number use case
class CheckPhoneNumber extends UseCase<bool, PhoneParams> {
  final AuthRepository repository;
  CheckPhoneNumber(this.repository);

  @override
  Future<Either<Failure, bool>> call(PhoneParams params) {
    return repository.checkPhoneNumber(params.phone, params.countryCode);
  }
}