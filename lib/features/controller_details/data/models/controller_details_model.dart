
class ControllerResponseModel {
  final int code;
  final String message;
  final ControllerDetails controllerDetails;
  final List<GroupDetails> groupDetails;

  ControllerResponseModel({
    required this.code,
    required this.message,
    required this.controllerDetails,
    required this.groupDetails,
  });

  factory ControllerResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return ControllerResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      controllerDetails: ControllerDetails.fromJson(data['controllerDetails'] ?? {}),
      groupDetails: (data['groupDetails'] as List<dynamic>? ?? [])
          .map((e) => GroupDetails.fromJson(e))
          .toList(),
    );
  }
}

class ControllerDetails {
  final String wpsIp;
  final String wpsPort;
  final String wapIp;
  final String wapPort;
  final String msgDesc;
  final String motorStatus;
  final String programNo;
  final String zoneNo;
  final String zoneRunTime;
  final String zoneRemainingTime;
  final String menuId;
  final String referenceId;
  final String setFlow;
  final String remFlow;
  final String flowRate;
  final String programName;
  final String simNumber;
  final String deviceName;
  final String manualStatus;
  final String dndStatus;
  final String mobileCountryCode;
  final int dealerId;
  final String dealerName;
  final int productId;
  final int oldProductId;
  final int userId;
  final int userDeviceId;
  final String dealerNumber;
  final String dealerCountryCode;
  final String deviceId;
  final String productDesc;
  final String dateOfManufacture;
  final int warrentyMonths;
  final String modelName;
  final int modelId;
  final String categoryName;
  final String operationMode;
  final String gprsMode;
  final String appSmsMode;
  final String groupName;
  final int groupId;
  final int serviceDealerId;
  final String serviceDealerName;
  final String serviceDealerCountryCode;
  final String serviceDealerMobileNumber;
  final String emailAddress;
  final int cctvStatusFlag;
  final String mobCctv;
  final String webCctv;
  final String customerName;
  final String customerNumber;
  final String customerCountryCode;
  final int customerUserId;

  ControllerDetails({
    required this.wpsIp,
    required this.wpsPort,
    required this.wapIp,
    required this.wapPort,
    required this.msgDesc,
    required this.motorStatus,
    required this.programNo,
    required this.zoneNo,
    required this.zoneRunTime,
    required this.zoneRemainingTime,
    required this.menuId,
    required this.referenceId,
    required this.setFlow,
    required this.remFlow,
    required this.flowRate,
    required this.programName,
    required this.simNumber,
    required this.deviceName,
    required this.manualStatus,
    required this.dndStatus,
    required this.mobileCountryCode,
    required this.dealerId,
    required this.dealerName,
    required this.productId,
    required this.oldProductId,
    required this.userId,
    required this.userDeviceId,
    required this.dealerNumber,
    required this.dealerCountryCode,
    required this.deviceId,
    required this.productDesc,
    required this.dateOfManufacture,
    required this.warrentyMonths,
    required this.modelName,
    required this.modelId,
    required this.categoryName,
    required this.operationMode,
    required this.gprsMode,
    required this.appSmsMode,
    required this.groupName,
    required this.groupId,
    required this.serviceDealerId,
    required this.serviceDealerName,
    required this.serviceDealerCountryCode,
    required this.serviceDealerMobileNumber,
    required this.emailAddress,
    required this.cctvStatusFlag,
    required this.mobCctv,
    required this.webCctv,
    required this.customerName,
    required this.customerNumber,
    required this.customerCountryCode,
    required this.customerUserId,
  });

  factory ControllerDetails.fromJson(Map<String, dynamic> json) {
    return ControllerDetails(
      wpsIp: json['wpsIp'] ?? '',
      wpsPort: json['wpsPort'] ?? '',
      wapIp: json['wapIp'] ?? '',
      wapPort: json['wapPort'] ?? '',
      msgDesc: json['msgDesc'] ?? '',
      motorStatus: json['motorStatus'] ?? '',
      programNo: json['programNo'] ?? '',
      zoneNo: json['zoneNo'] ?? '',
      zoneRunTime: json['ZoneRunTime'] ?? '',
      zoneRemainingTime: json['zoneRemainingTime'] ?? '',
      menuId: json['menuId'] ?? '',
      referenceId: json['referenceId'] ?? '',
      setFlow: json['setFlow'] ?? '',
      remFlow: json['remFlow'] ?? '',
      flowRate: json['flowRate'] ?? '',
      programName: json['programName'] ?? '',
      simNumber: json['simNumber'] ?? '',
      deviceName: json['deviceName'] ?? '',
      manualStatus: json['manualStatus'] ?? '',
      dndStatus: json['dndStatus'] ?? '',
      mobileCountryCode: json['mobileCountryCode'] ?? '',
      dealerId: json['dealerId'] ?? 0,
      dealerName: json['dealerName'] ?? '',
      productId: json['productId'] ?? 0,
      oldProductId: json['oldProductId'] ?? 0,
      userId: json['userId'] ?? 0,
      userDeviceId: json['userDeviceId'] ?? 0,
      dealerNumber: json['dealerNumber'] ?? '',
      dealerCountryCode: json['dealerCountryCode'] ?? '',
      deviceId: json['deviceId'] ?? '',
      productDesc: json['productDesc'] ?? '',
      dateOfManufacture: json['dateOfManufacture'] ?? '',
      warrentyMonths: json['warrentyMonths'] ?? 0,
      modelName: json['modelName'] ?? '',
      modelId: json['model_Id'] ?? 0,
      categoryName: json['categoryName'] ?? '',
      operationMode: json['operationMode'] ?? '',
      gprsMode: json['gprsMode'] ?? '',
      appSmsMode: json['appSmsMode'] ?? '',
      groupName: json['groupName'] ?? '',
      groupId: json['groupId'] ?? 0,
      serviceDealerId: json['serviceDealerId'] ?? 0,
      serviceDealerName: json['serviceDealerName'] ?? '',
      serviceDealerCountryCode: json['serviceDealerCountryCode'] ?? '',
      serviceDealerMobileNumber: json['serviceDealerMobileNumber'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      cctvStatusFlag: json['cctvStatusFlag'] ?? 0,
      mobCctv: json['mobCctv'] ?? '',
      webCctv: json['webCctv'] ?? '',
      customerName: json['customerName'] ?? '',
      customerNumber: json['customerNumber'] ?? '',
      customerCountryCode: json['customerCountryCode'] ?? '',
      customerUserId: json['customerUserId'] ?? 0,
    );
  }
}

class GroupDetails {
  final int userGroupId;
  final int userId;
  final String groupName;

  GroupDetails({
    required this.userGroupId,
    required this.userId,
    required this.groupName,
  });

  factory GroupDetails.fromJson(Map<String, dynamic> json) {
    return GroupDetails(
      userGroupId: json['userGroupId'] ?? 0,
      userId: json['userId'] ?? 0,
      groupName: json['groupName'] ?? '',
    );
  }
}
