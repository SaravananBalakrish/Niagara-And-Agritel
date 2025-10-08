// lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/route_constants.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../dashboard/presentation/bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import 'package:get_it/get_it.dart' as di;

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = di.GetIt.instance.get<DashboardBloc>();
        final authState = context.read<AuthBloc>().state;
        if (authState is Authenticated) {
          // Trigger fetch on bloc creation if authenticated
          if (bloc.state is! DashboardLoading &&
              bloc.state is! DashboardGroupsLoaded) {
            bloc.add(FetchDashboardGroupsEvent(authState.user.userDetails.id));
          }
        }
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        drawer: const AppDrawer(),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              final dashboardBloc = context.read<DashboardBloc>();
              if (dashboardBloc.state is! DashboardLoading && dashboardBloc.state is! DashboardGroupsLoaded) {
                dashboardBloc.add(FetchDashboardGroupsEvent(state.user.userDetails.id));
              }
            } else if (state is LoggedOut) {
              context.go(RouteConstants.login);
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, dashboardState) {
                    if (dashboardState is DashboardGroupsLoaded) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Welcome, ${authState.user.userDetails.name}!'),
                            Text('User ID: ${authState.user.userDetails.id}'),
                            Text('Mobile: ${authState.user.userDetails.mobile}'),
                            // Display groups
                            /* ...List<Widget>.generate(
                              (dashboardState.groups).length,
                              (index) => Text('Group: ${(dashboardState.groups as List<dynamic>)[index]['name'] ?? 'Unknown'}'),
                            ),*/
                            ElevatedButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(LogoutEvent());
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                    } else if (dashboardState is DashboardLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (dashboardState is DashboardError) {
                      return Center(child: Text('Error: ${dashboardState.message}'));
                    }
                    return const SizedBox.shrink();  // Fallback
                  },
                );
              } else if (authState is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (authState is AuthError) {
                return Center(child: Column(children: [Text('Error: ${authState.message}'), ElevatedButton(onPressed: () => context.read<AuthBloc>().add(CheckCachedUserEvent()), child: Text('Retry'))]));
              } else {
                return const Center(child: Text('Please log in'));
              }
            },
          ),
        ),
      ),
    );
  }
}