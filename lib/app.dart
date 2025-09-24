import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/di/injection.dart' as di;
import 'core/theme/theme_provider.dart';
import 'routes.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

Future<void> appMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const RootApp());
}

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  final _authBloc = di.sl<AuthBloc>();
  final _themeProvider = di.sl<ThemeProvider>();
  late final AppRouter _router;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _router = AppRouter(authBloc: _authBloc);
    _checkCachedUser();
  }

  Future<void> _checkCachedUser() async {
    _authBloc.add(CheckCachedUserEvent());
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeProvider),
        BlocProvider.value(value: _authBloc),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.theme,
            routerConfig: _router.router,
            /*builder: (context, child) =>
                FlavorBanner(child: child ?? const SizedBox()),*/
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }
}