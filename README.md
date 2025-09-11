```markdown
# Clean-Architecture + Flavors (example)

This repository layout combines Clean Architecture (feature-first) with multi-flavor support.

Key points:
- Use per-flavor native configuration (Android productFlavors, iOS xcconfigs / schemes) for bundle id, icons, Firebase files.
- Use separate Dart entrypoints per flavor (lib/main_dev.dart, lib/main_prod.dart) that call a shared app bootstrap (lib/app.dart).
- FlavorConfig is the single source of runtime environment values (apiBaseUrl, name, flags).
- Use DI (get_it / injectable) and register flavor-specific implementations during startup.

Run examples:
- flutter run --flavor dev -t lib/main_dev.dart
- flutter build apk --flavor prod -t lib/main_prod.dart

CI example builds both flavors. See .github/workflows/ci-flavors.yml
```