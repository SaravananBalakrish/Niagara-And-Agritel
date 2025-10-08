import 'package:flutter/material.dart';

class SyncSection extends StatelessWidget {
  final String liveSync;
  final String smsSync;

  const SyncSection({super.key, required this.liveSync, required this.smsSync});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Live Sync", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(liveSync, style: const TextStyle(fontSize: 12)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text("SMS Sync", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(smsSync, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
