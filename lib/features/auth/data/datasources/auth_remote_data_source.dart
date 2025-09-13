import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithOtp(String mobileNumber, String otp);
  Future<UserModel> loginWithPassword(String mobileNumber, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> loginWithOtp(String mobileNumber, String otp) async {
    final response = await apiClient.post('/auth/login-otp', body: {
      'mobile': mobileNumber,
      'otp': otp,
    });
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> loginWithPassword(String mobileNumber, String password) async {
    final response = await apiClient.post('/auth/login', body: {
      'mobile': mobileNumber,
      'password': password,
    });
    return UserModel.fromJson(response);
  }
}
