import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart' as di;
import 'core/utils/route_constants.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: RouteConstants.login,
      debugLogDiagnostics: true,
      /*refreshListenable: GoRouterRefreshStream(
        di.sl<AuthBloc>().stream,
      ),*/
      redirect: (context, state) {
        final authState = di.sl<AuthBloc>().state;
        final isLoggedIn = authState is AuthAuthenticated;

        // If user is not logged in, always go to login
        if (!isLoggedIn && state.matchedLocation != RouteConstants.login) {
          return RouteConstants.login;
        }

        // If user is logged in, prevent going back to login
        if (isLoggedIn && state.matchedLocation == RouteConstants.login) {
          return RouteConstants.dashboard;
        }

        return null; // no redirect
      },
      routes: [
        GoRoute(
          path: RouteConstants.login,
          builder: (context, state) {
            return BlocProvider.value(
              value: di.sl<AuthBloc>(),
              child: const LoginPage(),
            );
          },
        ),
        GoRoute(
          path: RouteConstants.dashboard,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text("Dashboard Page")),
          ),
        ),
      ],
    );
  }
}
