import '../../mqtt/utils/mqtt_message_helper.dart';
import '../domain/entities/livemessage_entity.dart';
import '../presentation/bloc/dashboard_bloc.dart';
import '../presentation/bloc/dashboard_event.dart';

class DashboardMessageDispatcher implements MessageDispatcher {
  final DashboardBloc dashboardBloc; // Injected

  DashboardMessageDispatcher({required this.dashboardBloc});

  @override
  void onLiveUpdate(String deviceId, LiveMessageEntity liveMessage) {
    dashboardBloc.add(UpdateLiveMessageEvent(deviceId, liveMessage));
  }

  @override
  void onFertilizerUpdate(String deviceId, String rawMessage) {
    // Handle fertilizer-specific event if exists
  }

  @override
  void onScheduleUpdate(String deviceId, String rawMessage) {
    // Handle schedule event if exists
  }

  @override
  void onSmsNotification(String deviceId, String message, String description) {
    // Optional: Add event for SMS if needed
  }
}