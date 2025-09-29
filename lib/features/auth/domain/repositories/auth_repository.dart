import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, RegisterDetailsEntity>> loginWithPassword(String phone, String password);
  Future<Either<Failure, String>> sendOtp(String phone);
  Future<Either<Failure, RegisterDetailsEntity>> verifyOtp(String phone, String otp, String countryCode);
  Future<Either<Failure, void>> logout(); // ✅ new
  Future<Either<Failure, bool>> checkPhoneNumber(String phone, String countryCode);
}
