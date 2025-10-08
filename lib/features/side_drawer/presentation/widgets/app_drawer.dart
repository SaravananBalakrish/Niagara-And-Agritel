import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/drawer_bloc.dart';
import '../bloc/drawer_state.dart';

class AppDrawer extends StatelessWidget {
  final Function(String itemId) onItemTap;

  const AppDrawer({Key? key, required this.onItemTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent, // Transparent base
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Frosted blur
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              // border: Border(
              //   right: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
              // ),
            ),
            child: BlocBuilder<DrawerBloc, DrawerState>(
              builder: (context, state) {
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildHeader(context, state),
                    // Drawer Items
                    ...state.items.where((item) => item.isVisible).map((item) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.15),
                              Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(item.icon, color: Colors.white),
                          title: Text(
                            item.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () => onItemTap(item.id),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DrawerState state) {
    return Container(
      decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.15),
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // border: Border.all(
        //   color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        // ),
      ),
      child: UserAccountsDrawerHeader(
        margin: EdgeInsets.zero,
         decoration: const BoxDecoration(color: Colors.transparent),
        accountName: Text(
          state.userName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        accountEmail: Text(
          state.userRole,
          style: const TextStyle(color: Colors.white70),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.3),
          child: Text(
            state.userName.isNotEmpty ? state.userName[0].toUpperCase() : "?",
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
