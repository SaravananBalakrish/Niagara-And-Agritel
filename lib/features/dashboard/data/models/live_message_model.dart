
import '../../domain/entities/livemessage_entity.dart';

class LiveMessageModel extends LiveMessageEntity {
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

  /// Parse from liveMessage string (MQTT cM field)
  factory LiveMessageModel.fromLiveMessage(String? message) {
    if (message == null || message.trim().isEmpty || message.trim().toUpperCase() == "NA") {
      return const LiveMessageModel(
        motorOnOff: '0',
        valveOnOff: '0',
        liveDisplay1: '',
        liveDisplay2: '',
        rVoltage: '0',
        yVoltage: '0',
        bVoltage: '0',
        ryVoltage: '0',
        ybVoltage: '0',
        brVoltage: '0',
        rCurrent: '0.0',
        yCurrent: '0.0',
        bCurrent: '0.0',
        modeOfOperation: '',
        programName: '',
        zoneNo: '0',
        valveForZone: '',
        zoneDuration: '00:00:00',
        zoneRemainingTime: '00:00:00',
        prsIn: '0.0',
        prsOut: '0.0',
        flowRate: '0.0',
        wellLevel: '0',
        fertStatus: <String>[],
        ec: '0',
        ph: '0',
        totalMeterFlow: '0',
        runTimeToday: '0',
        runTimePrevious: '0',
        flowPrevDay: '00:00:00',
        flowToday: '00:00:00',
        moisture1: '0',
        moisture2: '0',
        energy: '0',
        powerFactor: '0',
        fertValues: <String>[],
        versionModule: '',
        versionBoard: '',
      );
    }

    final parts = message.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

    // Safe access helper
    String safeString(int index, String defaultValue) => index < parts.length ? parts[index] : defaultValue;
    List<String> safeList(int index, List<String> defaultValue) {
      if (index >= parts.length) return defaultValue;
      final str = parts[index];
      if (str.contains(':')) {
        return str.split(':').map((s) => s.trim()).toList();
      } else if (str.contains(';')) {
        return str.split(';').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      }
      return [str];
    }

    // Parse specific fields
    final motorOnOff = safeString(0, '0');
    final valveOnOff = safeString(1, '0');
    final liveDisplay1 = safeString(3, '');
    final liveDisplay2 = safeString(4, '');
    final rVoltage = safeString(5, '0');
    final ryVoltage = safeString(6, '0');
    final yVoltage = safeString(7, '0');
    final ybVoltage = safeString(8, '0');
    final bVoltage = safeString(9, '0');
    final brVoltage = safeString(10, '0');
    final rCurrent = safeString(11, '0.0');
    final yCurrent = safeString(12, '0.0');
    final bCurrent = safeString(13, '0.0');
    final modeOfOperation = safeString(14, '');
    final programName = safeString(15, '');
    final zoneNo = safeString(16, '0');
    final valveForZone = safeString(17, '');
    final zoneDuration = safeString(18, '00:00:00');
    final zoneRemainingTime = safeString(19, '00:00:00');
    final prsIn = safeString(20, '0.0');
    final prsOut = safeString(23, '0.0');
    final flowRateTemp = safeString(25, '0.0:0');
    final flowParts = flowRateTemp.split(':');
    final flowRate = flowParts.length > 0 ? flowParts[0] : '0.0';
    final totalMeterFlow = flowParts.length > 1 ? flowParts[1] : '0';
    final wellLevel = safeString(34, '0'); // Assuming position for wellLevel
    final runTimeToday = safeString(35, '0');
    final flowPrevDay = safeString(27, '00:00:00');
    final flowToday = safeString(28, '00:00:00');
    final moisture1 = safeString(31, '0');
    final moisture2 = safeString(32, '0');
    final energy = safeString(29, '0');
    final powerFactor = safeString(30, '0');

    // Fert values
    final fertValues = safeList(24, <String>[]);

    // Fert status (run times, split by ';', take first 8)
    List<String> fertStatus = <String>[];
    String runTimePrevious = '0';
    String ec = '0';
    if (parts.length > 36) {
      final longPart = parts[36];
      final semiParts = longPart.split(';');
      if (semiParts.length >= 9) {
        fertStatus = semiParts.sublist(0, 8).map((s) => s.trim()).toList();
        ec = semiParts[8].trim();
        runTimePrevious = semiParts.sublist(0, 8).last.trim(); // Last run time as previous?
      } else {
        fertStatus = semiParts.map((s) => s.trim()).toList();
        if (semiParts.isNotEmpty) runTimePrevious = semiParts.last.trim();
      }
    }

    final ph = safeString(37, '0');
    final versionModule = safeString(39, '');
    final versionBoard = safeString(40, '');

    return LiveMessageModel(
      motorOnOff: motorOnOff,
      valveOnOff: valveOnOff,
      liveDisplay1: liveDisplay1,
      liveDisplay2: liveDisplay2,
      rVoltage: rVoltage,
      yVoltage: yVoltage,
      bVoltage: bVoltage,
      ryVoltage: ryVoltage,
      ybVoltage: ybVoltage,
      brVoltage: brVoltage,
      rCurrent: rCurrent,
      yCurrent: yCurrent,
      bCurrent: bCurrent,
      modeOfOperation: modeOfOperation,
      programName: programName,
      zoneNo: zoneNo,
      valveForZone: valveForZone,
      zoneDuration: zoneDuration,
      zoneRemainingTime: zoneRemainingTime,
      prsIn: prsIn,
      prsOut: prsOut,
      flowRate: flowRate,
      wellLevel: wellLevel,
      fertStatus: fertStatus,
      ec: ec,
      ph: ph,
      totalMeterFlow: totalMeterFlow,
      runTimeToday: runTimeToday,
      runTimePrevious: runTimePrevious,
      flowPrevDay: flowPrevDay,
      flowToday: flowToday,
      moisture1: moisture1,
      moisture2: moisture2,
      energy: energy,
      powerFactor: powerFactor,
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