import 'package:niagara_smart_drip_irrigation/features/dashboard/domain/entities/livemessage_entity.dart';

class LiveMessageModel extends LiveMessageEntity{
  const LiveMessageModel({
    required super.motorOnOff,
    required super.valveOnOff,
    required super.liveDisplay1,
    required super.liveDisplay2,
    required super.rVoltage,
    required super.yVoltage,
    required super.bVoltage,
    required super.ryVoltage,
    required super.ybVoltage,
    required super.brVoltage,
    required super.rCurrent,
    required super.yCurrent,
    required super.bCurrent,
    required super.modeOfOperation,
    required super.programName,
    required super.zoneNo,
    required super.valveForZone,
    required super.zoneDuration,
    required super.zoneRemainingTime,
    required super.prsIn,
    required super.prsOut,
    required super.flowRate,
    required super.wellLevel,
    required super.fertStatus,
    required super.ec,
    required super.ph,
    required super.totalMeterFlow,
    required super.runTimeToday,
    required super.runTimePrevious,
    required super.flowPrevDay,
    required super.flowToday,
    required super.moisture1,
    required super.moisture2,
    required super.energy,
    required super.powerFactor,
    required super.fertValues,
    required super.versionModule,
    required super.versionBoard,
  });

  /// Parse from liveMessage string
  factory LiveMessageModel.fromLiveMessage(String? message) {
    if (message == null ||
        message.trim().isEmpty ||
        message.trim().toUpperCase() == "NA") {
      return LiveMessageModel(
        motorOnOff: '0',
        valveOnOff: '0',
        liveDisplay1: '0',
        liveDisplay2: '0',
        rVoltage: '0',
        yVoltage: '0',
        bVoltage: '0',
        ryVoltage: '0',
        ybVoltage: '0',
        brVoltage: '0',
        rCurrent: '0',
        yCurrent: '0',
        bCurrent: '0',
        modeOfOperation: '0',
        programName: '0',
        zoneNo: '0',
        valveForZone: '0',
        zoneDuration: '0',
        zoneRemainingTime: '0',
        prsIn: '0',
        prsOut: '0',
        flowRate: '0',
        wellLevel: '0',
        fertStatus: ['0',],
        ec: '0',
        ph: '0',
        totalMeterFlow: '0',
        runTimeToday: '0',
        runTimePrevious: '0',
        flowPrevDay: '0',
        flowToday: '0',
        moisture1: '0',
        moisture2: '0',
        energy: '0',
        powerFactor: '0',
        fertValues: ['0',],
        versionModule: '0',
        versionBoard:'0',
      );
      throw Exception("Invalid live message");
    }

    final parts = message.split(",");

    String safe(int index) =>
        index < parts.length && parts[index].trim().isNotEmpty
            ? parts[index].trim()
            : "NA";

    // Fertilizer ON/OFF status (index 24)
    final fertStr = safe(24);
    final fertParts = fertStr.split(":");
    final fertStatus =
    List<String>.generate(6, (i) => fertParts.length > i ? fertParts[i] : "0");

    // EC:PH (index 25)
    final ecphStr = safe(25);
    final ecphParts = ecphStr.split(":");
    final ec = ecphParts.isNotEmpty ? ecphParts[0] : "0";
    final ph = ecphParts.length > 1 ? ecphParts[1] : "0";

    // Fertilizer values (index 36)
    List<String> fertValues = List.filled(6, "0");
    if (parts.length >= 37) {
      final fertValStr = safe(36);
      final fertValParts = fertValStr.split(";");
      fertValues = List<String>.generate(
          6, (i) => fertValParts.length > i ? fertValParts[i] : "0");
    }

    // Version info (index 39, 40)
    final versionModule = parts.length >= 40 ? safe(39) : "";
    final versionBoard = parts.length >= 41 ? safe(40) : "";

    return LiveMessageModel(
      motorOnOff: safe(0),
      valveOnOff: safe(1),
      liveDisplay1: safe(3),
      liveDisplay2: safe(4),
      rVoltage: safe(5),
      yVoltage: safe(6),
      bVoltage: safe(7),
      ryVoltage: safe(8),
      ybVoltage: safe(9),
      brVoltage: safe(10),
      rCurrent: safe(11),
      yCurrent: safe(12),
      bCurrent: safe(13),
      modeOfOperation: safe(14),
      programName: safe(15),
      zoneNo: safe(16),
      valveForZone: safe(17),
      zoneDuration: safe(18),
      zoneRemainingTime: safe(19),
      prsIn: safe(20),
      prsOut: safe(21),
      flowRate: safe(22),
      wellLevel: safe(23),
      fertStatus: fertStatus,
      ec: ec,
      ph: ph,
      totalMeterFlow: safe(26),
      runTimeToday: safe(27),
      runTimePrevious: safe(28),
      flowPrevDay: safe(29),
      flowToday: safe(30),
      moisture1: safe(31),
      moisture2: safe(32),
      energy: safe(33),
      powerFactor: safe(34),
      fertValues: fertValues,
      versionModule: versionModule,
      versionBoard: versionBoard,
    );
  }

  /// Convert back to JSON-like map (optional)
  Map<String, dynamic> toMap() => {
    "motorOnOff": motorOnOff,
    "valveOnOff": valveOnOff,
    "liveDisplay1": liveDisplay1,
    "liveDisplay2": liveDisplay2,
    "rVoltage": rVoltage,
    "yVoltage": yVoltage,
    "bVoltage": bVoltage,
    "ryVoltage": ryVoltage,
    "ybVoltage": ybVoltage,
    "brVoltage": brVoltage,
    "rCurrent": rCurrent,
    "yCurrent": yCurrent,
    "bCurrent": bCurrent,
    "modeOfOperation": modeOfOperation,
    "programName": programName,
    "zoneNo": zoneNo,
    "valveForZone": valveForZone,
    "zoneDuration": zoneDuration,
    "zoneRemainingTime": zoneRemainingTime,
    "prsIn": prsIn,
    "prsOut": prsOut,
    "flowRate": flowRate,
    "wellLevel": wellLevel,
    "fertStatus": fertStatus,
    "ec": ec,
    "ph": ph,
    "totalMeterFlow": totalMeterFlow,
    "runTimeToday": runTimeToday,
    "runTimePrevious": runTimePrevious,
    "flowPrevDay": flowPrevDay,
    "flowToday": flowToday,
    "moisture1": moisture1,
    "moisture2": moisture2,
    "energy": energy,
    "powerFactor": powerFactor,
    "fertValues": fertValues,
    "versionModule": versionModule,
    "versionBoard": versionBoard,
  };
}
