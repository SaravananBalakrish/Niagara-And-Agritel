import 'package:flutter/material.dart';
import 'core/flavor/flavor_config.dart';
import 'core/theme/app_themes.dart';
import 'core/flavor/flavor_widgets.dart';
import 'core/di/injection.dart' as di; // your DI init; call after FlavorConfig.setup

Future<void> appMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize DI - ensure your di.init() calls registerFlavorDependencies(sl)
  await di.init();

  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cfg = FlavorConfig.instance;
    final theme = AppThemes.themeFor(cfg.values.themeKey);

    return FlavorBanner(
      child: MaterialApp(
        title: cfg.values.displayName,
        theme: theme,
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final cfg = FlavorConfig.instance;
    return Scaffold(
      appBar: AppBar(title: Text(cfg.values.displayName)),
      body: Center(child: Text('Running ${cfg.values.displayName}')),
    );
  }
}