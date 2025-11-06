

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glassy_wrapper.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/presentation/pages/sign_up_page.dart';
import 'package:niagara_smart_drip_irrigation/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/presentation/pages/chat.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/presentation/pages/groups.dart';

import 'core/di/injection.dart' as di;
import 'core/utils/route_constants.dart';
import 'features/side_drawer/presentation/pages/sub_users.dart';
import 'features/side_drawer/presentation/widgets/app_drawer.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/otp_page.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/dealer_dashboard/presentation/pages/dealer_dashboard_page.dart';

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
  final AuthBloc authBloc;

  AppRouter({required this.authBloc}) {
    router = GoRouter(
      initialLocation: RouteConstants.login,
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isLoggedIn = authState is Authenticated;
        final isOtpSent = authState is OtpSent;

        print('GoRouter redirect: authState=$authState, currentLocation=${state.matchedLocation}');

        if (isOtpSent && state.matchedLocation != RouteConstants.verifyOtp) {
          print('Redirecting to OTP screen: ${RouteConstants.verifyOtp}');
          return RouteConstants.verifyOtp;
        }
        if (isLoggedIn &&
            (state.matchedLocation == RouteConstants.login ||
                state.matchedLocation == RouteConstants.verifyOtp)) {
          print('Redirecting to dashboard: ${RouteConstants.dashboard}');
          print(authState.user.userDetails.userType);
          if (authState.user.userDetails.userType == 2) {
            return RouteConstants.dealerDashboard;
          } else if (authState.user.userDetails.userType == 1) {
            return RouteConstants.dashboard;
          }
        }
        if (!isLoggedIn &&
            !isOtpSent &&
            state.matchedLocation != RouteConstants.login &&
            state.matchedLocation != RouteConstants.verifyOtp) {
          print('Redirecting to login: ${RouteConstants.login}');
          return RouteConstants.login;
        }
        print('No redirect needed');
        return null;
      },
      routes: [
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
            print('Building SignUpPage, AuthBloc state: ${authBloc.state}');
            return BlocProvider.value(
              value: authBloc,
              child: UserProfileForm(
                isEdit: false,
              ),
            );
          },
        ),
        GoRoute(
          name: 'editProfile',
          path: RouteConstants.editProfile,
          builder: (context, state) {
            print('Building EditProfile, AuthBloc state: ${authBloc.state}');
            final authState = authBloc.state;
            final initialData = authState is Authenticated ? authState.user.userDetails : null;
            return BlocProvider.value(
              value: authBloc,
              child: UserProfileForm(
                key: const ValueKey('editProfile'),
                isEdit: true,
                initialData: initialData,
              ),
            );
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
        ShellRoute(
          builder: (context, state, child) {
            final location = state.matchedLocation;
            String title = 'Dealer Dashboard';
            if (location == RouteConstants.groups) {
              title = 'Groups';
            } else if (location == RouteConstants.subUsers) {
              title = 'Sub Users';
            } else if (location == RouteConstants.chat) {
              title = 'Chat';
            }
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(title),
              ),
              drawer: const AppDrawer(),
              body: GlassyWrapper(
                child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (OverscrollIndicatorNotification notification) {
                      notification.disallowIndicator();
                      return true;
                    },
                    child: child
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: 'dealerDashboard',
              path: RouteConstants.dealerDashboard,
              builder: (context, state) {
                return BlocProvider.value(
                  value: authBloc,
                  child: const DealerDashboardPage(),
                );
              },
            ),
            GoRoute(
              name: 'groups',
              path: RouteConstants.groups,
              builder: (context, state) {
                return BlocProvider.value(
                  value: authBloc,
                  child: const Groups(),
                );
              },
            ),
            GoRoute(
              name: 'subUsers',
              path: RouteConstants.subUsers,
              builder: (context, state) {
                return BlocProvider.value(
                  value: authBloc,
                  child: const SubUsers(),
                );
              },
            ),
            GoRoute(
              name: 'chat',
              path: RouteConstants.chat,
              builder: (context, state) {
                return BlocProvider.value(
                  value: authBloc,
                  child: const Chat(),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppBarBackground() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.06),
                Colors.white.withOpacity(0.02)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -60,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.white.withOpacity(0.06), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          right: -80,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.white.withOpacity(0.04), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}