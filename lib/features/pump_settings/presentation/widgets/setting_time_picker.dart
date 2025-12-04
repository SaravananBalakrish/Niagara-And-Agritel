import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class SettingTimePicker extends StatefulWidget {
  final String initialTime;
  final ValueChanged<String> onTimeChanged;
  final VoidCallback? onDone;

  const SettingTimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
    this.onDone,
  });

  @override
  State<SettingTimePicker> createState() => _SettingTimePickerState();
}

class _SettingTimePickerState extends State<SettingTimePicker> {
  late DateTime currentTime;
  late bool hasSeconds;

  @override
  void initState() {
    super.initState();
    currentTime = _parseTime(widget.initialTime);
    hasSeconds = widget.initialTime.trim().split(':').length == 3;
  }

  DateTime _parseTime(String s) {
    final parts = s.trim().split(':');
    final hour = int.parse(parts[0].padLeft(2, '0')).clamp(0, 23);
    final minute = parts.length > 1 ? int.parse(parts[1].padLeft(2, '0')).clamp(0, 59) : 0;
    final second = parts.length > 2 ? int.parse(parts[2].padLeft(2, '0')).clamp(0, 59) : 0;
    return DateTime(2025, 1, 1, hour, minute, second);
  }

  String _formatTime() {
    final h = currentTime.hour.toString().padLeft(2, '0');
    final m = currentTime.minute.toString().padLeft(2, '0');
    final s = currentTime.second.toString().padLeft(2, '0');
    return (hasSeconds) ? '$h:$m:$s' : '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Time',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, _formatTime());
                    widget.onDone?.call();
                  },
                  child: const Text('Done', style: TextStyle(fontSize: 18, color: Colors.deepPurple)),
                ),
              ],
            ),
          ),

          Expanded(
            child: TimePickerSpinner(
              time: currentTime,
              is24HourMode: true,
              alignment: Alignment.center,
              spacing: 50,
              itemHeight: 80,
              isForce2Digits: true,
              normalTextStyle: const TextStyle(fontSize: 32, color: Colors.grey),
              onTimeChange: (newTime) {
                setState(() => currentTime = newTime);
                widget.onTimeChanged(_formatTime()); // Live update
              },
              isShowSeconds: hasSeconds,
            ),
          ),
        ],
      ),
    );
  }
}

class TimePickerBottomSheet extends StatelessWidget {
  final String initialTime;
  final bool showSeconds;

  const TimePickerBottomSheet({
    super.key,
    required this.initialTime,
    this.showSeconds = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SettingTimePicker(
        initialTime: initialTime,
        onTimeChanged: (time) {
          // Live update (optional)
        },
        onDone: () {
          Navigator.pop(context, initialTime); // We'll override this
        },
      ),
    );
  }
}

/// Usage
/* showModalBottomSheet(
   context: context,
   isScrollControlled: true,
   backgroundColor: Colors.transparent,
   builder: (_) => CustomHmsTimePicker(
     initialTime: "14:35:27",
     showSeconds: true,
     onTimeChanged: (newTime) {
       setState(() => selectedTime = newTime); // Updates instantly
     },
   ),
);*/