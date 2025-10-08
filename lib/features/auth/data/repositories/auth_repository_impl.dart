import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthException {
  final String statusCode;
  final String message;

  AuthException({required this.statusCode, required this.message});
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl({required this.remote, required this.local});

  @override
  Future<Either<Failure, UserEntity>> loginWithPassword(String phone, String password) async {
    try {
      final user = await remote.loginWithPassword(phone, password);
      await local.cacheUser(user);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(code: e.statusCode, message: e.message));
    } catch (e) {
      return Left(ServerFailure('Login failed: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> sendOtp(String phone) async {
    try {
      final result = await remote.sendOtp(phone);
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(code: e.statusCode, message: e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to send OTP: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp(String verificationId, String otp, String countryCode) async {
    try {
      final user = await remote.verifyOtp(verificationId, otp, countryCode);
      print("user in the verifyOtp :: $user");
      await local.cacheUser(user);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(code: e.statusCode, message: e.message));
    } catch (e) {
      return Left(ServerFailure('OTP verification failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remote.logout();
      await local.clearUser();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(code: e.statusCode, message: e.message));
    } catch (e) {
      return Left(ServerFailure('Logout failed: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkPhoneNumber(String phone, String countryCode) async {
    try {
      final exists = await remote.checkPhoneNumber(phone, countryCode);
      return Right(exists);
    } on AuthException catch (e) {
      return Left(AuthFailure(code: e.statusCode, message: e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to check phone number: $e'));
    }
  }
}

class AuthFailure extends Failure {
  final String code;

  const AuthFailure({required this.code, required String message}) : super(message);

  @override
  List<Object?> get props => [code, message];
}