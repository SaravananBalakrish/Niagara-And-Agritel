// Small helpers to register flavor-specific dependencies.
//
// Usage:
// - Call FlavorConfig.setup(...) in per-flavor entrypoint
// - Call your DI init and inside it call registerFlavorDependencies(sl)

import 'package:get_it/get_it.dart';
import 'flavor_config.dart';

abstract class ExampleService {
  String get info;
}

class ExampleServiceImpl implements ExampleService {
  final String flavorName;
  ExampleServiceImpl(this.flavorName);
  @override
  String get info => 'Service for $flavorName';
}

void registerFlavorDependencies(GetIt sl) {
  final cfg = FlavorConfig.instance;

  // Example: register a flavor-aware ExampleService
  sl.registerLazySingleton<ExampleService>(() => ExampleServiceImpl(cfg.values.displayName));

  // Register other flavor-specific services (analytics, crashlytics) here...
}