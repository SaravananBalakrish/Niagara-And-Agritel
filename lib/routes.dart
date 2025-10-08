

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/presentation/pages/sign_up_page.dart';
import 'package:niagara_smart_drip_irrigation/features/dashboard/presentation/pages/dashboard_page.dart';

import 'core/di/injection.dart' as di;
import 'core/utils/route_constants.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/otp_page.dart';
import 'features/dealer_dashboard/presentation/pages/dealer_dashboard_page.dart';
import 'features/my_device/presentation/pages/my_device_page.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  StreamSubscription? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class AppRouter {
  late final GoRouter router;
  final AuthBloc authBloc; // Add AuthBloc parameter
//
  AppRouter({required this.authBloc}) {
    router = GoRouter(
      initialLocation: RouteConstants.myDevicePage,
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(authBloc.stream), // Use provided authBloc
      redirect: (context, state) {
        final authState = authBloc.state; // Use provided authBloc
        final isLoggedIn = authState is Authenticated;
        final isOtpSent = authState is OtpSent;

        print('GoRouter redirect: authState=$authState, currentLocation=${state.matchedLocation}');

        if (isOtpSent && state.matchedLocation != RouteConstants.verifyOtp) {
          print('Redirecting to OTP screen: ${RouteConstants.verifyOtp}');
          return RouteConstants.verifyOtp;
          return RouteConstants.dealerDashboard;
        }
        if (isLoggedIn &&
            (state.matchedLocation == RouteConstants.login ||
                state.matchedLocation == RouteConstants.verifyOtp)) {
          print('Redirecting to dashboard: ${RouteConstants.dashboard}');
          return RouteConstants.dashboard;
          return RouteConstants.dealerDashboard;
        }
        if (!isLoggedIn &&
            !isOtpSent &&
            state.matchedLocation != RouteConstants.login &&
            state.matchedLocation != RouteConstants.verifyOtp) {
          print('Redirecting to login: ${RouteConstants.login}');
          return RouteConstants.login;
          return RouteConstants.dealerDashboard;
        }
        print('No redirect needed');
        return null;
      },
      routes: [
        //RouteConstants.signUp
        GoRoute(
          name: 'login',
          path: RouteConstants.login,
          builder: (context, state) {
            print('Building LoginPage, AuthBloc state: ${authBloc.state}');
            return BlocProvider.value(
              value: authBloc,
              child: const LoginPage(),
            );
          },
        ),
        GoRoute(
          name: 'signUp',
          path: RouteConstants.signUp,
          builder: (context, state) {
            print('Building LoginPage, AuthBloc state: ${authBloc.state}');
            return const SignUpPage();
          },
        ),
        GoRoute(
          name: 'verifyOtp',
          path: RouteConstants.verifyOtp,
          builder: (context, state) {
            print('Building OtpVerificationPage, AuthBloc state: ${authBloc.state}');
            final authState = authBloc.state;
            final params = state.extra is Map ? state.extra as Map : null;
            final verificationId = params?['verificationId'] ?? (authState is OtpSent ? authState.verificationId : '');
            final phone = params?['phone'] ?? (authState is OtpSent ? authState.phone : '');
            final countryCode = params?['countryCode'] ?? (authState is OtpSent ? authState.countryCode : '');

            if (verificationId.isEmpty || phone.isEmpty) {
              print('Invalid OTP parameters, redirecting to login');
              return const LoginPage();
            }

            return BlocProvider.value(
              value: authBloc,
              child: OtpVerificationPage(
                verificationId: verificationId,
                phone: phone,
                countryCode: countryCode,
              ),
            );
          },
        ),
        GoRoute(
          name: 'dashboard',
          path: RouteConstants.dashboard,
          builder: (context, state) {
            print('Building DashboardPage, AuthBloc state: ${authBloc.state}');  // Add for debug
            return BlocProvider.value(
              value: authBloc,
              child: const DashboardPage(),
            );
          },
        ),
        GoRoute(
          path: RouteConstants.dealerDashboard,
          builder: (context, state) => DealerDashboardPage(dealerId: '1'),
        ),
        GoRoute(
          path: RouteConstants.myDevicePage,
          builder: (context, state) => MyDevicePage(),
        ),
      ],
    );
  }
}