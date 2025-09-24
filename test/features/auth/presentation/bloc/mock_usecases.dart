import 'package:mocktail/mocktail.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/domain/usecases/login_usecase.dart';

class MockLoginWithPassword extends Mock implements LoginWithPassword {}
class MockSendOtp extends Mock implements SendOtp {}
class MockVerifyOtp extends Mock implements VerifyOtp {}
class MockLogout extends Mock implements Logout {}
