import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithPassword(String phone, String password);
  Future<Either<Failure, String>> sendOtp(String phone);
  Future<Either<Failure, UserEntity>> verifyOtp(String phone, String otp);
  Future<Either<Failure, void>> logout(); // ✅ new
  Future<Either<Failure, bool>> checkPhoneNumber(String phone, String countryCode);
}
