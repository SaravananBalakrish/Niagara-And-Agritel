
import 'package:flutter/material.dart';

import '../../domain/entities/drawer_item.dart';

class DrawerState {
  final String userName;
  final String userRole;
  final List<DrawerItem> items;

  const DrawerState({
    required this.userName,
    required this.userRole,
    required this.items,
  });

  factory DrawerState.initial({String userName = "Guest", String userRole = "User"}) {
    return DrawerState(
      userName: userName,
      userRole: userRole,
      items: _itemsForRole(userRole),
    );
  }

  DrawerState copyWith({
    String? userName,
    String? userRole,
    List<DrawerItem>? items,
  }) {
    return DrawerState(
      userName: userName ?? this.userName,
      userRole: userRole ?? this.userRole,
      items: items ?? this.items,
    );
  }

  static List<DrawerItem> _itemsForRole(String role) {
    switch (role) {
      case "Admin":
        return [
          const DrawerItem(id: "home", title: "Home", icon: Icons.home),
          const DrawerItem(id: "group", title: "Manage Groups", icon: Icons.group),
          const DrawerItem(id: "users", title: "Manage Users", icon: Icons.people),
          const DrawerItem(id: "chat", title: "Chat", icon: Icons.chat),
          const DrawerItem(id: "reminder", title: "Reminders", icon: Icons.alarm),
          const DrawerItem(id: "logout", title: "Logout", icon: Icons.logout),
        ];
      case "Dealer":
        return [
          const DrawerItem(id: "home", title: "Home", icon: Icons.home),
          const DrawerItem(id: "subusers", title: "Sub Users", icon: Icons.person_add),
          const DrawerItem(id: "chat", title: "Chat", icon: Icons.chat),
          const DrawerItem(id: "edit_profile", title: "Edit Profile", icon: Icons.edit),
          const DrawerItem(id: "logout", title: "Logout", icon: Icons.logout),
        ];
      default:
        return [
          const DrawerItem(id: "home", title: "Home", icon: Icons.home),
          const DrawerItem(id: "group", title: "Manage Groups", icon: Icons.group),
          const DrawerItem(id: "edit_profile", title: "Edit Profile", icon: Icons.edit),
          const DrawerItem(id: "subusers", title: "SubUsers", icon: Icons.people),
          const DrawerItem(id: "chat", title: "Chat", icon: Icons.chat),
          const DrawerItem(id: "reminder", title: "Reminders", icon: Icons.alarm),
          const DrawerItem(id: "logout", title: "Logout", icon: Icons.logout),
        ];
    }
  }
}
