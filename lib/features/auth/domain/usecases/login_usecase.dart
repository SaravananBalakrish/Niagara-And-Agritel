import '../repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserModel> call({
    required String mobileNumber,
    String? otp,
    String? password,
  }) async {
    if (otp != null) {
      return repository.loginWithOtp(mobileNumber, otp);
    } else if (password != null) {
      return repository.loginWithPassword(mobileNumber, password);
    } else {
      throw Exception('OTP or password must be provided');
    }
  }

  Future<void> logout() async {
    await repository.logout();
  }
}
