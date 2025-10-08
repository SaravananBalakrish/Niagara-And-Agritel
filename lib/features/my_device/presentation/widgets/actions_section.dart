import 'package:flutter/material.dart';

class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key});

  Widget _buildAction(IconData icon, String label) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            child: Icon(icon, size: 28),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAction(Icons.settings, "Pump Settings"),
        _buildAction(Icons.insert_chart, "Report"),
        _buildAction(Icons.send, "Send & Receive"),
        _buildAction(Icons.touch_app, "Standalone"),
        _buildAction(Icons.warning, "Alert"),
        _buildAction(Icons.agriculture, "Irrigation"),
      ],
    );
  }
}
