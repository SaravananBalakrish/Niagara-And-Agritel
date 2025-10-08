import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MotorValveSection extends StatelessWidget {
  final bool motorOn;
  final bool valveOn;

  const MotorValveSection({super.key, required this.motorOn, required this.valveOn});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(
          !motorOn
              ? 'assets/images/common/ui_motor.gif'       // motor ON
              : motorOn
              ? 'assets/images/common/live_motor_off.png' // motor OFF
              : 'assets/images/common/ui_motor_yellow.png', // no status
          width: 60,
          height: 60,
        ),
        // Icon(Icons.water, size: 60, color: motorOn ? Colors.green : Colors.red),
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                AnimatedSwitcher(duration: const Duration(milliseconds: 400));
                HapticFeedback.mediumImpact();
                },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("ON"),
            ),
            const SizedBox(height: 6),
            ElevatedButton(
              onPressed: () {
                AnimatedSwitcher(duration: const Duration(milliseconds: 400));
                HapticFeedback.mediumImpact();
                },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("OFF"),
            ),
          ],

        ),
        Image.asset(
          !valveOn
              ? 'assets/images/common/valve_open.gif'                  // valve open
              : valveOn
              ? 'assets/images/common/valve_stop.png'            // valve stop
              : 'assets/images/common/valve_no_communication.png', // no communication
          width: 60,
          height: 60,
        ),
      ],
    );
  }
}

