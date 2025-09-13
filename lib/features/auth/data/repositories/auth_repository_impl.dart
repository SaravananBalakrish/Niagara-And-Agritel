import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../../data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl({required this.remote, required this.local});

  @override
  Future<UserModel> loginWithOtp(String mobileNumber, String otp) async {
    final user = await remote.loginWithOtp(mobileNumber, otp);
    await local.cacheUser(user);
    return user;
  }

  @override
  Future<UserModel> loginWithPassword(String mobileNumber, String password) async {
    final user = await remote.loginWithPassword(mobileNumber, password);
    await local.cacheUser(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await local.clearUser();
  }
}
