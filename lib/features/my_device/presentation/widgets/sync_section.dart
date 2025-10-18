import 'package:flutter/material.dart';
import 'package:niagara_smart_drip_irrigation/common_widget/glass_effect.dart';

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
            Text(liveSync, style: const TextStyle(fontSize: 12,color: Colors.white)),
          ],
        ),
        ProgramButton(programTitle: 'Program 1'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text("SMS Sync", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(smsSync, style: const TextStyle(fontSize: 12,color: Colors.white)),
          ],
        ),
      ],
    );
  }
}


class ProgramButton extends StatelessWidget {
  final String programTitle;

  const ProgramButton({
    super.key,
    required this.programTitle,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding:  const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: TextButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$programTitle clicked!')),
          );
        },
        icon: const Icon(Icons.remove_red_eye, color: Colors.white),
        label: Text(
          programTitle,
          style: const TextStyle(color: Colors.white),
        ),
      
      ),
    );
  }
}