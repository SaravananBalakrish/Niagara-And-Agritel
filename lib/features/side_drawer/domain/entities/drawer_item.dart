import 'package:flutter/material.dart';

class DrawerItem {
  final String id;
  final String title;
  final IconData icon;
  final bool isVisible;

  const DrawerItem({
    required this.id,
    required this.title,
    required this.icon,
    this.isVisible = true,
  });

  DrawerItem copyWith({bool? isVisible}) {
    return DrawerItem(
      id: id,
      title: title,
      icon: icon,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}
