import 'package:flutter/material.dart';

class PressureSection extends StatelessWidget {
  final double prsIn;
  final double prsOut;
  final String activeZone;

  const PressureSection({
    super.key,
    required this.prsIn,
    required this.prsOut,
    required this.activeZone,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Prs IN: $prsIn"),
        Text(activeZone, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text("Prs OUT: $prsOut"),
      ],
    );
  }
}
