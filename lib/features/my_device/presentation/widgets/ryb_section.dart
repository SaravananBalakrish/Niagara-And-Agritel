import 'package:flutter/material.dart';

class RYBSection extends StatelessWidget {
  final int r, y, b;
  final double c1, c2, c3;

  const RYBSection({
    super.key,
    required this.r,
    required this.y,
    required this.b,
    required this.c1,
    required this.c2,
    required this.c3,
  });

  Widget _buildBox(Color color, String line1, String line2, String line3) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(line1, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(line2,style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(line3,style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildBox(Colors.red.shade300, "RY $r V", "R $r V", "C1 $c1 A"),
        _buildBox(Colors.yellow.shade300, "YB $y V", "Y $y V", "C2 $c2 A"),
        _buildBox(Colors.blue.shade300, "BR $b V", "B $b V", "C3 $c3 A"),
      ],
    );
  }
}
