class MyDeviceControllerEntity {
  final String id;
  final String name;
  final bool mqttConnected;
  final String liveSync;
  final String smsSync;
  final int signal;
  final int battery;
  final String status;
  final int vrb;
  final double amp;
  final int r, y, b;
  final double c1, c2, c3;
  final bool motorOn;
  final bool valveOn;
  final double prsIn, prsOut;
  final String activeZone;
  final String setTime, remainingTime;
  final int tabIndex;

  MyDeviceControllerEntity({
    required this.id,
    required this.name,
    required this.mqttConnected,
    required this.liveSync,
    required this.smsSync,
    required this.signal,
    required this.battery,
    required this.status,
    required this.vrb,
    required this.amp,
    required this.r,
    required this.y,
    required this.b,
    required this.c1,
    required this.c2,
    required this.c3,
    required this.motorOn,
    required this.valveOn,
    required this.prsIn,
    required this.prsOut,
    required this.activeZone,
    required this.setTime,
    required this.remainingTime,
    required this.tabIndex,
  });
}
