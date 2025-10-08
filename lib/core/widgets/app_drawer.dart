// lib/core/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/dashboard/presentation/bloc/dashboard_event.dart';
import '../../core/utils/route_constants.dart';
import '../../features/dashboard/presentation/bloc/dashboard_state.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header with User Info
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              String userName = 'Guest';
              String? userEmail;
              int? userId;

              if (authState is Authenticated) {
                userName = authState.user.userDetails.name;
                userEmail = authState.user.userDetails.email;
                userId = authState.user.userDetails.id;
                final dashboardBloc = context.read<DashboardBloc>();
                if (dashboardBloc.state is! DashboardLoading && dashboardBloc.state is! DashboardGroupsLoaded) {
                  dashboardBloc.add(FetchDashboardGroupsEvent(authState.user.userDetails.id));
                }
                // context.read<DashboardBloc>().add(FetchDashboardGroupsEvent(userId));
                // Trigger fetching groups only once using BlocListener in parent
              }

              return UserAccountsDrawerHeader(
                accountName: Text(
                  userName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onDetailsPressed: () {
                  context.push(RouteConstants.signUp);
                },
                accountEmail: Text(
                  userEmail ?? 'No email',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'G',
                    style: TextStyle(
                      fontSize: 24,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              );
            },
          ),
          // Home
          _buildDrawerItem(
            context,
            icon: Icons.home,
            title: 'Home',
            route: RouteConstants.dashboard,
          ),
          // Groups (Dynamic Content)
          _buildDrawerItem(
            context,
            icon: Icons.group_work,
            title: 'Groups',
            route: RouteConstants.dashboard,
          ),
          const Divider(),
          // Sub Users
          _buildDrawerItem(
            context,
            icon: Icons.group,
            title: 'Sub Users',
            // route: RouteConstants.subUsers, // Add this route
          ),
          // Chat
          _buildDrawerItem(
            context,
            icon: Icons.chat,
            title: 'Chat',
            // route: RouteConstants.chat, // Add this route
          ),
          // Reminder
          _buildDrawerItem(
            context,
            icon: Icons.alarm,
            title: 'Reminder',
            // route: RouteConstants.reminder, // Add this route
          ),
          const Divider(),
          // Conditional Login/Logout
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return _buildDrawerItem(
                  context,
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    context.read<AuthBloc>().add(LogoutEvent());
                    Navigator.pop(context);
                  },
                );
              }
              return _buildDrawerItem(
                context,
                icon: Icons.login,
                title: 'Login',
                route: RouteConstants.login,
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper method to build drawer items
  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? route,
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (route != null) {
          context.go(route);
          Navigator.pop(context);
        }
      },
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    );
  }
}