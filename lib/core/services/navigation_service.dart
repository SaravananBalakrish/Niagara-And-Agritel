import 'package:flutter/material.dart';

import '../../features/pump_settings/presentation/widgets/setting_time_picker.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static Future<String?> showTimePicker({
    required String initialTime,
    bool showSeconds = true,
  }) async {
    if (context == null) return null;

    return await showDialog<String>(
      context: context!,
      builder: (_) => TimePickerBottomSheet(
        initialTime: initialTime,
        showSeconds: showSeconds,
      ),
    );
  }
}