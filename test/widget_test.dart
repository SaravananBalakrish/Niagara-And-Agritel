import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niagara_smart_drip_irrigation/app.dart';
import 'package:niagara_smart_drip_irrigation/core/flavor/flavor_config.dart';

void main() {
  setUp(() {
    // Ensure flavor is set before building the widget tree.
    FlavorConfig.setup(Flavor.niagara);
  });

  testWidgets('RootApp shows flavor display name', (WidgetTester tester) async {
    await tester.pumpWidget(const RootApp());

    // Replace with the title/text you expect from RootApp/HomePage
    expect(find.text('Niagara'), findsOneWidget);
  });
}