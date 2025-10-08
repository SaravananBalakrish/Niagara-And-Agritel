import 'package:flutter/material.dart';

class TimerSection extends StatelessWidget {
  final String setTime;
  final String remainingTime;

  const TimerSection({super.key, required this.setTime, required this.remainingTime});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text("Set Time", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(setTime),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text("Remaining Time", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(remainingTime),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
