import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:niagara_smart_drip_irrigation/core/error/failures.dart';
import 'package:niagara_smart_drip_irrigation/core/usecases/usecase.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/domain/entities/user_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/domain/usecases/login_usecase.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/presentation/bloc/auth_event.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/presentation/bloc/auth_state.dart';

class MockLoginWithPassword extends Mock implements LoginWithPassword {}
class MockSendOtp extends Mock implements SendOtp {}
class MockVerifyOtp extends Mock implements VerifyOtp {}
class MockLogout extends Mock implements Logout {}
class MockCheckPhoneNumber extends Mock implements CheckPhoneNumber {}

void main() {
  late AuthBloc authBloc;
  late MockLoginWithPassword mockLoginWithPassword;
  late MockSendOtp mockSendOtp;
  late MockVerifyOtp mockVerifyOtp;
  late MockCheckPhoneNumber mockCheckPhoneNumber;
  late MockLogout mockLogout;

  setUp(() {
    mockLoginWithPassword = MockLoginWithPassword();
    mockSendOtp = MockSendOtp();
    mockVerifyOtp = MockVerifyOtp();
    mockLogout = MockLogout();
    mockCheckPhoneNumber = MockCheckPhoneNumber();
    authBloc = AuthBloc(
      loginWithPassword: mockLoginWithPassword,
      sendOtp: mockSendOtp,
      verifyOtp: mockVerifyOtp,
      logout: mockLogout,
      checkPhoneNumber: mockCheckPhoneNumber
    );
  });

  final tUser = UserEntity(id: 1, name: 'Test User', mobile: '1234567890', accessToken: '');
  final tLoginParams = LoginParams(phone: '1234567890', password: 'password');
  final tPhoneParams = PhoneParams('1234567890', '+91');
  final tVerifyOtpParams = VerifyOtpParams(verificationId: '1234567890', otp: '123456', countryCode: '+91');
  const tNoParams = NoParams();

  group('LoginWithPasswordEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when LoginWithPasswordEvent is successful',
      build: () {
        when(() => mockLoginWithPassword(tLoginParams))
            .thenAnswer((_) async => Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginWithPasswordEvent(tLoginParams)),
      expect: () => [AuthLoading(), Authenticated(tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when LoginWithPasswordEvent fails',
      build: () {
        when(() => mockLoginWithPassword(tLoginParams))
            .thenAnswer((_) async => Left(ServerFailure('Login failed')));
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginWithPasswordEvent(tLoginParams)),
      expect: () => [AuthLoading(), AuthError(message: 'Login failed')],
    );
  });

  group('SendOtpEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, OtpSent] when SendOtpEvent is successful',
      build: () {
        when(() => mockSendOtp(tPhoneParams))
            .thenAnswer((_) async => const Right(''));
        return authBloc;
      },
      act: (bloc) => bloc.add(SendOtpEvent(tPhoneParams)),
      expect: () => [AuthLoading(), OtpSent(verificationId: '', phone: '', countryCode: '+91')],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when SendOtpEvent fails',
      build: () {
        when(() => mockSendOtp(tPhoneParams))
            .thenAnswer((_) async => Left(ServerFailure('OTP send failed')));
        return authBloc;
      },
      act: (bloc) => bloc.add(SendOtpEvent(tPhoneParams)),
      expect: () => [AuthLoading(), AuthError(message: 'OTP send failed')],
    );
  });

  group('VerifyOtpEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when VerifyOtpEvent is successful',
      build: () {
        when(() => mockVerifyOtp(tVerifyOtpParams))
            .thenAnswer((_) async => Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(VerifyOtpEvent(tVerifyOtpParams)),
      expect: () => [AuthLoading(), Authenticated(tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when VerifyOtpEvent fails',
      build: () {
        when(() => mockVerifyOtp(tVerifyOtpParams))
            .thenAnswer((_) async => Left(ServerFailure('OTP verification failed')));
        return authBloc;
      },
      act: (bloc) => bloc.add(VerifyOtpEvent(tVerifyOtpParams)),
      expect: () => [AuthLoading(), AuthError(message: 'OTP verification failed')],
    );
  });

  group('LogoutEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, LoggedOut] when LogoutEvent is successful',
      build: () {
        when(() => mockLogout(tNoParams))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [AuthLoading(), LoggedOut()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when LogoutEvent fails',
      build: () {
        when(() => mockLogout(tNoParams))
            .thenAnswer((_) async => Left(ServerFailure('Logout failed')));
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [AuthLoading(), AuthError(message: 'Logout failed')],
    );
  });
}