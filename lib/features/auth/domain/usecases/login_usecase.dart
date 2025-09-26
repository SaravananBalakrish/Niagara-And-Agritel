import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Login with password use case
class LoginWithPassword extends UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;
  LoginWithPassword(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.loginWithPassword(params.phone, params.password);
  }
}

class LoginParams {
  final String phone;
  final String password;

  LoginParams({required this.phone, required this.password});
}

/// Send OTP use case
class SendOtp extends UseCase<void, PhoneParams> {
  final AuthRepository repository;
  SendOtp(this.repository);

  @override
  Future<Either<Failure, String>> call(PhoneParams params) {
    return repository.sendOtp(params.phone);
  }
}

class PhoneParams {
  final String phone;
  final String countryCode;
  PhoneParams(this.phone, this.countryCode);
}

/// Verify OTP use case
class VerifyOtp extends UseCase<UserEntity, VerifyOtpParams> {
  final AuthRepository repository;
  VerifyOtp(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(VerifyOtpParams params) {
    return repository.verifyOtp(params.phone, params.otp, params.verificationId);
  }
}

class VerifyOtpParams {
  final String verificationId;
  final String phone;
  final String otp;

  VerifyOtpParams({required this.verificationId, required this.otp, required this.phone});
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