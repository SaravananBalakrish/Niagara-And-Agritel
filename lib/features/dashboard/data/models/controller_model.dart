import 'package:niagara_smart_drip_irrigation/features/dashboard/data/models/live_message_model.dart';

import '../../domain/entities/controller_entity.dart';
import 'dart:convert'; // Add this import for jsonDecode

class ProgramModel extends ProgramEntity {
  const ProgramModel({
    required super.programId,
    required super.programNameDefault,
    required super.programName,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      programId: json['programId'] as int,
      programNameDefault: json['programNameDefault'] as String,
      programName: json['programName'] as String,
    );
  }
}

class ControllerModel extends ControllerEntity {
  const ControllerModel({
    required super.userDeviceId,
    required super.fertilizerMessage,
    required super.filterMessage,
    required super.userId,
    required super.appSmsMode,
    required super.status,
    required super.ctrlStatusFlag,
    required super.power,
    required super.status1,
    required super.msgcode,
    required super.ctrlLatestMsg,
    required super.liveMessage,
    required super.relaystatus,
    required super.operationMode,
    required super.gprsMode,
    required super.dndStatus,
    required super.mobCctv,
    required super.webCctv,
    required super.simNumber,
    required super.deviceName,
    required super.deviceId,
    required super.modelId,
    required super.livesyncDate,
    required super.livesyncTime,
    required super.programList,
    required super.wpsIp,
    required super.wpsPort,
    required super.wapIp,
    required super.wapPort,
    required super.userProgramName,
    required super.msgDesc,
    required super.motorStatus,
    required super.programNo,
    required super.zoneNo,
    required super.zoneRunTime,
    required super.zoneRemainingTime,
    required super.menuId,
    required super.referenceId,
    required super.setFlow,
    required super.remFlow,
    required super.flowRate,
  });

  factory ControllerModel.fromJson(Map<String, dynamic> json) {

    print("liveMessage :: ${json['liveMessage']}");

    List<ProgramModel> parsedProgramList;
    final programListRaw = json['programList'];
    if (programListRaw is String) {
      try {
        final List<dynamic> decodedList = jsonDecode(programListRaw);
        parsedProgramList = decodedList
            .map((e) => ProgramModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        print('Error parsing programList string: $e');
        parsedProgramList = const [];
      }
    } else if (programListRaw is List<dynamic>) {
      parsedProgramList = (programListRaw)
          .map((e) => ProgramModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      parsedProgramList = const [];
    }
    
    

    return ControllerModel(
      userDeviceId: json['userDeviceId'],
      fertilizerMessage: json['fertilizerMessage'],
      filterMessage: json['filterMessage'],
      userId: json['userId'],
      appSmsMode: json['appSmsMode'],
      status: json['status'],
      ctrlStatusFlag: json['ctrlStatusFlag'],
      power: json['Power'],
      status1: json['status1'],
      msgcode: json['msgcode'],
      ctrlLatestMsg: json['ctrlLatestMsg'],
      liveMessage: LiveMessageModel.fromLiveMessage(json['liveMessage']),
      relaystatus: json['relaystatus'],
      operationMode: json['operationMode'],
      gprsMode: json['gprsMode'],
      dndStatus: json['dndStatus'],
      mobCctv: json['mobCctv'],
      webCctv: json['webCctv'],
      simNumber: json['simNumber'],
      deviceName: json['deviceName'],
      deviceId: json['deviceId'],
      modelId: json['model_Id'],
      livesyncDate: json['livesyncDate'],
      livesyncTime: json['livesyncTime'],
      programList: parsedProgramList,
      wpsIp: json['wpsIp'],
      wpsPort: json['wpsPort'],
      wapIp: json['wapIp'],
      wapPort: json['wapPort'],
      userProgramName: json['userProgramName'],
      msgDesc: json['msgDesc'],
      motorStatus: json['motorStatus'],
      programNo: json['programNo'],
      zoneNo: json['zoneNo'],
      zoneRunTime: json['ZoneRunTime'],
      zoneRemainingTime: json['zoneRemainingTime'],
      menuId: json['menuId'],
      referenceId: json['referenceId'],
      setFlow: json['setFlow'],
      remFlow: json['remFlow'],
      flowRate: json['flowRate'],
    );
  }
}