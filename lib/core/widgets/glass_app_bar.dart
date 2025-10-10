import 'dart:ui';
import 'package:flutter/material.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double? toolbarHeight;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final double? elevation;

  const GlassAppBar({
    super.key,
    this.title,
    this.actions,
    this.bottom,
    this.toolbarHeight,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      title: title,
      actions: actions,
      bottom: bottom,
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0,
      flexibleSpace: ClipRRect( // Add the glassy blur here
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(isDark ? 0.06 : 0.1),
                  Colors.white.withOpacity(isDark ? 0.02 : 0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Standard AppBar height
}