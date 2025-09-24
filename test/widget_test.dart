import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart' hide reset;
import 'package:niagara_smart_drip_irrigation/core/di/injection.dart';
import 'package:niagara_smart_drip_irrigation/core/di/injection.dart' as di;
import 'package:niagara_smart_drip_irrigation/core/flavor/flavor_config.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/presentation/bloc/auth_state.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/presentation/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockAuthBloc extends Mock implements AuthBloc {}
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late MockAuthBloc mockAuthBloc;

  // In setUpAll for widget_with_di_test.dart
  setUpAll(() async {
    mockSharedPreferences = MockSharedPreferences();
    when(() => mockSharedPreferences.getString(any())).thenReturn(null);
    when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);
    when(() => mockSharedPreferences.remove(any())).thenAnswer((_) async => true);

    final mockHttpClient = MockHttpClient();
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response('{}', 200));

    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthInitial()));
    when(() => mockAuthBloc.close()).thenAnswer((_) async => Future.value());
    di.sl.registerFactory<AuthBloc>(() => mockAuthBloc);

    FlavorConfig.setupFromDartDefine();

    await di.init(clear: true, prefs: mockSharedPreferences, httpClient: mockHttpClient);
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthInitial()));
    when(() => mockAuthBloc.close()).thenAnswer((_) async => Future.value()); // Mock close method
  });

  tearDownAll(() async {
    await reset(); // Reset GetIt
  });

  testWidgets('LoginPage shows phone input and login button', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>(
          create: (_) => mockAuthBloc,
          child: const LoginPage(),
        ),
      ),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Login with Password'), findsOneWidget);
  });
}