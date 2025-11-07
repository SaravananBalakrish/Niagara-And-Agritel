import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/utils/route_constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              String userName = 'Guest';
              int userType = 0;
              String? mobile;

              if (authState is Authenticated) {
                userName = authState.user.userDetails.name;
                mobile = authState.user.userDetails.mobile;
                userType = authState.user.userDetails.userType;
              }

              return UserAccountsDrawerHeader(
                currentAccountPictureSize: const Size(double.maxFinite, 70),
                accountName: Text(
                  userName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  mobile != null && mobile.isNotEmpty ? mobile : '+91 123456789',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                currentAccountPicture: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Text(
                            userName.isNotEmpty ? userName[0].toUpperCase() : 'G',
                            style: TextStyle(
                              fontSize: 22,  // Adjusted for smaller radius
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push(RouteConstants.editProfile);
                      },
                      icon: const Icon(Icons.edit, size: 16, color: Colors.white70),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        foregroundColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              String? homeRoute;
              if (authState is Authenticated) {
                final userType = authState.user.userDetails.userType;
                homeRoute = userType == 2 ? RouteConstants.dealerDashboard : RouteConstants.dashboard;
              } else {
                homeRoute = RouteConstants.login;
              }

              return _buildDrawerItem(
                context,
                icon: Icons.home,
                title: 'Home',
                route: homeRoute,
              );
            },
          ),
          // Groups (Dynamic Content)
          _buildDrawerItem(
            context,
            icon: Icons.group_work,
            title: 'Groups',
            route: RouteConstants.groups,
          ),
          const Divider(),
          // Sub Users
          _buildDrawerItem(
            context,
            icon: Icons.group,
            title: 'Sub Users',
            route: RouteConstants.subUsers,
          ),
          // Chat
          _buildDrawerItem(
            context,
            icon: Icons.chat,
            title: 'Chat',
            route: RouteConstants.chat,
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
                    context.go(RouteConstants.login);
                    // context.pop();
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