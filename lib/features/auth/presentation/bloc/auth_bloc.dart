import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart' as di;
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithPassword loginWithPassword;
  final SendOtp sendOtp;
  final VerifyOtp verifyOtp;
  final Logout logout;

  AuthBloc({
    required this.loginWithPassword,
    required this.sendOtp,
    required this.verifyOtp,
    required this.logout,
  }) : super(AuthInitial()) {
    on<LoginWithPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await loginWithPassword(event.params);
      result.fold(
        (failure) => emit(failure is AuthFailure
            ? AuthError(message: failure.message, code: failure.code)
            : AuthError(message: failure.message)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<SendOtpEvent>((event, emit) async {
      print('Processing SendOtpEvent: phone=${event.params.phone}');
      emit(AuthLoading());
      final result = await sendOtp(event.params);
      result.fold(
        (failure) {
          print('SendOtpEvent failed: $failure');
          emit(failure is AuthFailure
              ? AuthError(message: failure.message, code: failure.code)
              : AuthError(message: failure.message));
        },
        (verificationId) {
          print('SendOtpEvent succeeded: verificationId=$verificationId, phone=${event.params.phone}');
          emit(OtpSent(
            verificationId: verificationId,
            phone: event.params.phone,
          ));
        },
      );
    });

    on<VerifyOtpEvent>((event, emit) async {
      print('Processing VerifyOtpEvent: verificationId=${event.params.verificationId}, otp=${event.params.otp}');
      emit(AuthLoading());
      final result = await verifyOtp(event.params);
      result.fold(
        (failure) {
          print('VerifyOtpEvent failed: $failure');
          emit(failure is AuthFailure
              ? AuthError(message: failure.message, code: failure.code)
              : AuthError(message: failure.message));
        },
        (user) => emit(Authenticated(user)),
      );
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await logout(event.params);
      result.fold(
        (failure) => emit(failure is AuthFailure
            ? AuthError(message: failure.message, code: failure.code)
            : AuthError(message: failure.message)),
        (_) => emit(LoggedOut()),
      );
    });

    on<CheckCachedUserEvent>((event, emit) async {
      final localDataSource = di.sl<AuthLocalDataSource>();
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        emit(Authenticated(cachedUser));
      } else {
        emit(AuthInitial());
      }
    });
  }
}