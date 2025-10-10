import 'package:flutter/material.dart';

class GlassyWrapper extends StatelessWidget {
  final Widget? child;

  const GlassyWrapper({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base glassy gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.surfaceVariant,
              ],
            ),
          ),
        ),
        // Subtle decorations (orbs for depth)
        Positioned.fill(
          child: _buildBackgroundDecorations(context),
        ),
        // Child content (your pages)
        child ?? const SizedBox(),
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