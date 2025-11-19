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
  Future<Either<Failure, RegisterDetailsEntity>> call(LoginParams updateSubUserDetailsParams) {
    return repository.loginWithPassword(updateSubUserDetailsParams.phone, updateSubUserDetailsParams.password);
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
  Future<Either<Failure, String>> call(PhoneParams updateSubUserDetailsParams) {
    final fullPhone = updateSubUserDetailsParams.phone.startsWith('+') ? updateSubUserDetailsParams.phone : updateSubUserDetailsParams.countryCode + updateSubUserDetailsParams.phone;
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
  Future<Either<Failure, RegisterDetailsEntity>> call(VerifyOtpParams updateSubUserDetailsParams) {
    return repository.verifyOtp(updateSubUserDetailsParams.verificationId, updateSubUserDetailsParams.otp, updateSubUserDetailsParams.countryCode);
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
  Future<Either<Failure, void>> call(NoParams updateSubUserDetailsParams) {
    return repository.logout();
  }
}

/// Check Phone Number use case
class CheckPhoneNumber extends UseCase<bool, PhoneParams> {
  final AuthRepository repository;
  CheckPhoneNumber(this.repository);

  @override
  Future<Either<Failure, bool>> call(PhoneParams updateSubUserDetailsParams) {
    return repository.checkPhoneNumber(updateSubUserDetailsParams.phone, updateSubUserDetailsParams.countryCode);
  }
}

class SignUp extends UseCase<RegisterDetailsEntity, SignUpParams> {
  final AuthRepository repository;
  SignUp(this.repository);

  @override
  Future<Either<Failure, RegisterDetailsEntity>> call(SignUpParams updateSubUserDetailsParams) {
    return repository.signUp(updateSubUserDetailsParams);
  }
}

class SignUpParams extends Equatable {
  final String mobile;
  final String name;
  final int? userType; // e.g., from dropdown 'option'
  final String? addressOne;
  final String? addressTwo;
  final String? town;
  final String? village;
  final String? country;
  final String? state;
  final String? city;
  final String? postalCode;
  final String? altPhone;
  final String? email;
  final String? password;

  const SignUpParams({
    required this.mobile,
    required this.name,
    required this.userType,
    required this.addressOne,
    required this.addressTwo,
    required this.town,
    required this.village,
    required this.country,
    required this.state,
    required this.city,
    required this.postalCode,
    required this.altPhone,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [mobile, name, userType, addressOne, addressTwo, town, village, country, state, city, postalCode, altPhone, email, password];
}

class UpdateProfile extends UseCase<RegisterDetailsEntity, UpdateProfileParams> {
  final AuthRepository repository;
  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, RegisterDetailsEntity>> call(UpdateProfileParams updateSubUserDetailsParams) {
    return repository.updateProfile(updateSubUserDetailsParams);
  }
}

class UpdateProfileParams extends Equatable {
  final int id;
  final String name;
  final String? addressOne;
  final String mobile;
  final int? userType;
  final String? addressTwo;
  final String? town;
  final String? village;
  final String? country;
  final String? state;
  final String? city;
  final String? postalCode;
  final String? altPhone;
  final String? email;
  final String? password;
  const UpdateProfileParams({
    required this.addressOne,
    required this.mobile,
    required this.userType,
    required this.addressTwo,
    required this.town,
    required this.village,
    required this.country,
    required this.state,
    required this.city,
    required this.postalCode,
    required this.altPhone,
    required this.email,
    required this.password,
    required this.id,
    required this.name});

  @override
  List<Object?> get props => [
    addressOne,
    mobile,
    userType,
    addressTwo,
    town,
    village,
    country,
    state,
    city,
    postalCode,
    altPhone,
    email,
    password,
    id,
    name
  ];
}