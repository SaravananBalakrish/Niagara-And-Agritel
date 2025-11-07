// Updated routes.dart - Simplified to focus on routing only; UI logic extracted to pages/widgets
import 'dart:async';

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
import 'features/auth/domain/entities/user_entity.dart';
import 'features/side_drawer/domain/usecases/add_group_usecase.dart';
import 'features/side_drawer/domain/usecases/group_fetching_usecase.dart';
import 'features/side_drawer/presentation/bloc/group_bloc.dart';
import 'features/side_drawer/presentation/bloc/group_event.dart';
import 'features/side_drawer/presentation/pages/sub_users.dart';
import 'features/side_drawer/presentation/widgets/app_drawer.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/otp_page.dart';
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

        if (isOtpSent && state.matchedLocation != RouteConstants.verifyOtp) {
          return RouteConstants.verifyOtp;
        }
        if (isLoggedIn &&
            (state.matchedLocation == RouteConstants.login ||
                state.matchedLocation == RouteConstants.verifyOtp)) {
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
          return RouteConstants.login;
        }
        return null;
      },
      routes: [
        _authRoute(
          name: 'login',
          path: RouteConstants.login,
          builder: (context, state) => const LoginPage(),
        ),
        _authRoute(
          name: 'signUp',
          path: RouteConstants.signUp,
          builder: (context, state) => UserProfileForm(isEdit: false),
        ),
        _authRoute(
          name: 'editProfile',
          path: RouteConstants.editProfile,
          builder: (context, state) {
            final authState = authBloc.state;
            final initialData = authState is Authenticated ? authState.user.userDetails : null;
            return UserProfileForm(
              key: const ValueKey('editProfile'),
              isEdit: true,
              initialData: initialData,
            );
          },
        ),
        _authRoute(
          name: 'verifyOtp',
          path: RouteConstants.verifyOtp,
          builder: (context, state) {
            final authState = authBloc.state;
            final params = state.extra is Map ? state.extra as Map : null;
            final verificationId = params?['verificationId'] ?? (authState is OtpSent ? authState.verificationId : '');
            final phone = params?['phone'] ?? (authState is OtpSent ? authState.phone : '');
            final countryCode = params?['countryCode'] ?? (authState is OtpSent ? authState.countryCode : '');

            if (verificationId.isEmpty || phone.isEmpty) {
              return const LoginPage();
            }

            return OtpVerificationPage(
              verificationId: verificationId,
              phone: phone,
              countryCode: countryCode,
            );
          },
        ),
        GoRoute(
          name: 'dashboard',
          path: RouteConstants.dashboard,
          builder: (context, state) {
            final authData = _getAuthData();
            return BlocProvider.value(
              value: authBloc,
              child: DashboardPage(userId: authData.id, userType: authData.userType),
            );
          },
        ),
        ShellRoute(
          builder: (context, state, child) {
            final location = state.matchedLocation;
            String title = 'Dealer Dashboard';
            if (location == RouteConstants.groups) title = 'Groups';
            else if (location == RouteConstants.subUsers) title = 'Sub Users';
            else if (location == RouteConstants.chat) title = 'Chat';

            return BlocProvider.value(
              value: authBloc,
              child: Scaffold(
                appBar: AppBar(centerTitle: true, title: Text(title)),
                drawer: const AppDrawer(),
                body: GlassyWrapper(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (notification) {
                      notification.disallowIndicator();
                      return true;
                    },
                    child: child,
                  ),
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: 'dealerDashboard',
              path: RouteConstants.dealerDashboard,
              builder: (context, state) => BlocProvider.value(
                value: authBloc,
                child: const DealerDashboardPage(),
              ),
            ),
            GoRoute(
              name: 'groups',
              path: RouteConstants.groups,
              builder: (context, state) {
                final authData = _getAuthData();
                final groupFetchingUseCase = di.sl<GroupFetchingUsecase>();
                final groupAddingUseCase = di.sl<GroupAddingUsecase>();
                return BlocProvider(
                  create: (context) => GroupBloc(
                    groupFetchingUsecase: groupFetchingUseCase,
                    groupAddingUsecase: groupAddingUseCase,
                  )..add(FetchGroupsEvent(authData.id)),
                  child: GroupsPage(userId: authData.id),
                );
              },
            ),
            _protectedRoute(
              name: 'subUsers',
              path: RouteConstants.subUsers,
              builder: (context, state) => const SubUsers(),
            ),
            _protectedRoute(
              name: 'chat',
              path: RouteConstants.chat,
              builder: (context, state) => const Chat(),
            ),
          ],
        ),
      ],
    );
  }

  UserEntity _getAuthData() {
    final authState = authBloc.state;
    if (authState is Authenticated) {
      return authState.user.userDetails;
    }
    return UserEntity(
      id: 0,
      name: '',
      mobile: '',
      userType: 0,
      deviceToken: '',
      mobCctv: '',
      webCctv: '',
      altPhoneNum: [],
    );
  }

  Widget _buildWithAuthBloc(Widget child) => BlocProvider.value(value: authBloc, child: child);

  GoRoute _authRoute({
    required String name,
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
  }) {
    return GoRoute(
      name: name,
      path: path,
      builder: (context, state) => _buildWithAuthBloc(builder(context, state)),
    );
  }

  GoRoute _protectedRoute({
    required String name,
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
  }) {
    return GoRoute(
      name: name,
      path: path,
      builder: (context, state) => _buildWithAuthBloc(builder(context, state)),
    );
  }
}