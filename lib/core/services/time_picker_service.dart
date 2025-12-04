import 'package:flutter/material.dart';

import '../../features/pump_settings/presentation/widgets/setting_time_picker.dart';

class TimePickerService {
  static Future<String?> show({
    required BuildContext context,
    required String initialTime,
    bool showSeconds = true,
  }) async {
    return await showDialog<String>(
      context: context,
      builder: (_) => TimePickerBottomSheet(
        initialTime: initialTime,
        showSeconds: showSeconds,
      ),
    );
  }
}