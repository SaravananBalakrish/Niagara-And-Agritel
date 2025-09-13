import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> loginWithOtp(String mobileNumber, String otp);
  Future<UserModel> loginWithPassword(String mobileNumber, String password);
  Future<void> logout();
}
