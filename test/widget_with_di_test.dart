import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:niagara_smart_drip_irrigation/app.dart';
import 'package:niagara_smart_drip_irrigation/core/di/injection.dart' as di;
import 'package:niagara_smart_drip_irrigation/core/flavor/flavor_config.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/presentation/bloc/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late MockAuthBloc mockAuthBloc;

  setUpAll(() async {
    // Mock SharedPreferences
    mockSharedPreferences = MockSharedPreferences();
    when(() => mockSharedPreferences.getString(any())).thenReturn(null);
    when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);
    when(() => mockSharedPreferences.remove(any())).thenAnswer((_) async => true);

    // Mock AuthBloc
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthInitial()));
    when(() => mockAuthBloc.close()).thenAnswer((_) async => Future.value());

    // Register mock AuthBloc
    di.sl.registerFactory<AuthBloc>(() => mockAuthBloc);

    // Initialize FlavorConfig
    FlavorConfig.setupFromDartDefine();

    // Initialize GetIt with mock prefs
    await di.init(clear: true, prefs: mockSharedPreferences);
  });

  tearDownAll(() async {
    await di.reset(); // Reset GetIt
  });

  testWidgets('App boots with DI', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: RootApp(authBloc: mockAuthBloc,),
      ),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Niagara'), findsOneWidget);
  });
}