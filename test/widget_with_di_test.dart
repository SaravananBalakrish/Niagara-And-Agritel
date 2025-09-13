import 'package:flutter_test/flutter_test.dart';
import 'package:niagara_smart_drip_irrigation/app.dart';
import 'package:niagara_smart_drip_irrigation/core/flavor/flavor_config.dart';
import 'package:niagara_smart_drip_irrigation/core/di/injection.dart' as di;

void main() {
  setUpAll(() async {
    FlavorConfig.setup(Flavor.niagara);
    // reset ensures a clean graph for tests
    // await di.reset();
    await di.init(clear: true);

    // register any mocks/test doubles here, e.g.:
    // di.sl.registerSingleton<SomeRepo>(MockSomeRepo());
  });

  testWidgets('App boots with DI', (tester) async {
    await tester.pumpWidget(const RootApp());
    await tester.pumpAndSettle();

    expect(find.text('Niagara'), findsOneWidget);
  });
}