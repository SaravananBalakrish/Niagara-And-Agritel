import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;

class GlassyWrapper extends StatelessWidget {
  final Widget? child;
  final bool fixedBackground;

  const GlassyWrapper({
    super.key,
    this.child,
    this.fixedBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [
      // Base glassy gradient background - positioned to fill the stack
      Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Colors.black87,
              ],
            ),
          ),
        ),
      ),
      // Subtle decorations (orbs for depth)
      Positioned.fill(
        child: _buildBackgroundDecorations(context),
      ),
    ];

    // Child content layer
    if (child != null) {
      if (fixedBackground) {
        // For scrollable children (e.g., RefreshIndicator): Add as non-positioned child to allow internal scrolling/translation without moving the whole layer
        stackChildren.add(child!);
      } else {
        // Default: Position child to fill for static/full-bleed content
        stackChildren.add(Positioned.fill(child: child!));
      }
    }

    return Stack(
      children: stackChildren,
    );
  }

  Widget _buildBackgroundDecorations(BuildContext context) {
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