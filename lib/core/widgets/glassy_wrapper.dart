import 'package:flutter/material.dart';

class GlassyWrapper extends StatelessWidget {
  final Widget? child;

  const GlassyWrapper({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base glassy gradient background - now positioned to fill the stack
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
        // Child content (your pages) - now positioned to fill and respect bounds
        if (child != null) Positioned.fill(child: child!),
      ],
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