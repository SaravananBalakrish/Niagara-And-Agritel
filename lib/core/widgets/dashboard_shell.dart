// lib/core/widgets/dashboard_shell.dart (new file)
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/dashboard/presentation/bloc/dashboard_event.dart';
import '../../features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardShell extends StatelessWidget {
  final Widget child;  // Injected body from child routes
  final String? title;  // Optional custom AppBar title

  const DashboardShell({
    super.key,
    required this.child,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          final dashboardBloc = context.read<DashboardBloc>();
          if (dashboardBloc.state is! DashboardLoading &&
              dashboardBloc.state is! DashboardGroupsLoaded) {
            dashboardBloc.add(FetchDashboardGroupsEvent(state.user.userDetails.id));
          }
        } else if (state is LoggedOut) {
          // Handle logout redirect if needed (router handles it)
          context.read<AuthBloc>().add(LogoutEvent());  // Optional
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,  // For glassy effects
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(title ?? 'Home', style: const TextStyle(fontWeight: FontWeight.w600)),
          // Add flexibleSpace for background blur if needed (copy from DealerDashboardPage)
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.06), Colors.white.withOpacity(0.02)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
        ),
        drawer: const AppDrawer(),  // Shared drawer
        body: child,  // Child route content goes here
      ),
    );
  }
}