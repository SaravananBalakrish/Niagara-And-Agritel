import 'package:flutter/material.dart';

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
    ];

    // Child content layer
    stackChildren.add(Positioned.fill(child: child!));

    return Stack(
      children: stackChildren,
    );
  }

}