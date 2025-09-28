import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/data/models/user_model.dart';
import 'mock_api_client.dart';

void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = AuthRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  test("should return UserModel when loginWithPassword succeeds", () async {
    when(() => mockApiClient.post('/auth/login', body: any(named: 'body')))
        .thenAnswer((_) async => {'id': '1', 'mobile': '9999999999'});

    final result = await dataSource.loginWithPassword('9999999999', 'password123');

    expect(result, isA<UserModel>());
  });

  test("should call apiClient.post for sendOtp", () async {
    when(() => mockApiClient.post('/auth/send-otp', body: any(named: 'body')))
        .thenAnswer((_) async => null); // Void response

    await dataSource.sendOtp('9999999999');

    verify(() => mockApiClient.post('/auth/send-otp', body: {'mobile': '9999999999'})).called(1);
  });

  test("should return UserModel when verifyOtp succeeds", () async {
    when(() => mockApiClient.post('/auth/verify-otp', body: any(named: 'body')))
        .thenAnswer((_) async => {'id': '1', 'name': 'Test', 'mobile': '9999999999'});

    final result = await dataSource.verifyOtp('9999999999', '123456', '+91');

    expect(result, isA<UserModel>());
    verify(() => mockApiClient.post('/auth/verify-otp', body: {'mobile': '9999999999', 'otp': '123456'})).called(1);
  });

  test("should call apiClient.post for logout", () async {
    when(() => mockApiClient.post('/auth/logout', body: any(named: 'body')))
        .thenAnswer((_) async => null); // Void response

    await dataSource.logout();

    verify(() => mockApiClient.post('/auth/logout')).called(1);
  });
}
