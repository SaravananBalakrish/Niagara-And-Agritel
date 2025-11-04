class ControllerLiveMessageEntity {
  final String msgType;
  final String display1;
  final String display2;
  final String rVal;
  final String yVal;
  final String bVal;
  final String ryVal;
  final String ybVal;
  final String brVal;
  final String c1Val;
  final String c2Val;
  final String c3Val;
  final String modeOfOperation;
  final String programName;
  final String zoneNo;
  final String zoneDuration;
  final String zoneRemainingTime;
  final String setFlow;
  final String remainingFlow;
  final String moisture;
  final String level;
  final String fert1;
  final String fert2;
  final String fert3;
  final String fert4;
  final String pressure;
  final String totalMeterFlow;
  final String flowRate;
  final String flowPrevDay;
  final String flowTdy;
  final String energy;
  final String powerFactor;
  final String moisture1;
  final String moisture2;
  final String level1;
  final String level2;
  final String levelSet1;
  final String levelSet2;
  final String lowerTank;
  final String upperTank;
  final String wellLevel;
  final String signalStrength;
  final String extraData;
  final String runtimeToday;
  final String runtimePrevious;

  const ControllerLiveMessageEntity({
    required this.msgType,
    required this.display1,
    required this.display2,
    required this.rVal,
    required this.yVal,
    required this.bVal,
    required this.ryVal,
    required this.ybVal,
    required this.brVal,
    required this.c1Val,
    required this.c2Val,
    required this.c3Val,
    required this.modeOfOperation,
    required this.programName,
    required this.zoneNo,
    required this.zoneDuration,
    required this.zoneRemainingTime,
    required this.setFlow,
    required this.remainingFlow,
    required this.moisture,
    required this.level,
    required this.fert1,
    required this.fert2,
    required this.fert3,
    required this.fert4,
    required this.pressure,
    required this.totalMeterFlow,
    required this.flowRate,
    required this.flowPrevDay,
    required this.flowTdy,
    required this.energy,
    required this.powerFactor,
    required this.moisture1,
    required this.moisture2,
    required this.level1,
    required this.level2,
    required this.levelSet1,
    required this.levelSet2,
    required this.lowerTank,
    required this.upperTank,
    required this.wellLevel,
    required this.signalStrength,
    required this.extraData,
    required this.runtimeToday,
    required this.runtimePrevious,
  });
}
