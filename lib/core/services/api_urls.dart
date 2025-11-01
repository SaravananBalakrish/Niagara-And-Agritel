class ApiUrls {
  //TODO: AUTH URLs
  static const String getAddress = '/maps/api/geocode/json?';
  static const String signUp = 'user';
  static const String loginWithOtpUrl = 'signin1';
  static const String loginWithPasswordUrl = 'signin';
  static const String logOutUrl = 'signout';
  static const String simVerification = 'verifysim';
  static const String smsVerification = 'controller';
  static const String forgotPassword = 'forgotpassword';
  static const String getProfile = 'user/:userId';
  static const String editProfile = 'user';
  static const String verifyUserUrl = 'verifyUser';

  //TODO: DEALER URLs
  static const String getSellingUnit = 'dealer/:userId/category/:categoryId';
  static const String getSales = 'dealer/sales';
  static const String deviceTraceDealer = 'dealer/:userId/tracecode/:deviceId';
  static const String getDealerDetails = 'dealer/:userId/product/:deviceId/details';
  static const String addController = 'dealer/controller';
  static const String getDealerCustomerDetails = 'dealer/:userId/customer';
  static const String getDealerCustomerDeviceDetails = 'dealer/:dealerId/user/:userId/controller';

  //TODO: SUBUSER URLs
  static const String getSubUSer = 'user/:mobileno/details';
  static const String getSubUserDetails = 'user/:userId/shareuser/:mSubUserCode/details';
  static const String addSubUser = 'user/share/controller';
  static const String getSubUserList = 'user/:userId/shareuser/list';
  static const String deleteSubUserDetails = 'user/:userId/shareuser/:shareUserId';
  static const String updateSubUserDetails = 'user/share/controller';

  //TODO: GROUP URLs
  static const String getGroupValues = 'user/:userId/cluster';
  static const String addGroupValues = 'user/:userId/cluster';
  static const String updateGroupValues = 'user/:userId/cluster';
  static const String deleteGroupValues = 'user/:userId/cluster/:groupId';

  //TODO: SHARED URLs
  static const String getCustomerSharedDevice = 'user/:userId/invitee/list';
  static const String getCustomerSharedDeviceListItem = 'user/:userId/share/:shareId/controller';

  //TODO: REPORT URLs
  static const String getPowerData = 'user/:userId/subuser/:subuserId/controller/:controllerId/power/graph?';
  static const String getValveData = 'user/:userId/subuser/:subuserId/controller/:controllerId/zone/graph?';
  static const String getOnOffStatus = 'user/:userId/subuser/:subuserId/controller/:userDeviceId/manualstatus';
  static const String updateNotification = 'user/:userId/subuser/:subuserId/controller/:controllerId/message';

  //TODO: MY DEVICES URLs
  static const String getMyDevicesWithoutGroupList = 'controller/user/:userId';
  static const String getMyDevicesWithGroupList = 'controller/user/:userId/cluster';
  static const String getMyDevicesWithGroupItemList = 'user/:userId/cluster/:groupId/controller';
  static const String getSellingDevices = ':categorylist';

  //TODO: CONTROLLER URLs
  static const String getViewControllerCustomerDetails = 'user/:userId/subuser/:subuserId/controller/:userDeviceId/view';
  static const String deleteViewControllerCustomerDetails = 'user/:userId/controller/:userDeviceId';
  static const String updateController = 'controller';

  //TODO: PROGRAM URLs
  static const String getProgramList = 'user/:userId/controller/:controllerId/program';
  static const String getProgramsNodes = 'user/:userId/controller/:controllerId/program/:programId/node';

  //TODO: ZONE URLs
  static const String addZoneNodes = 'user/:userId/controller/:controllerId/program/:programId/zone';
  static const String updateZoneNodes = 'user/:userId/controller/:controllerId/program/:programId/zone';
  static const String resetZoneNodes = 'user/:userId/controller/:controllerId/program/:programId/zone/:zoneId?';
  static const String getZoneDetails = 'user/:userId/controller/:controllerId/program/:programId/zone/:zoneNumber';

  //TODO: NODE URLs
  static const String deviceTrace = 'tracecode/:deviceId/?type=ctrl';
  static const String nodeTrace = 'tracecode/:deviceId?type=node';
  static const String addNode = 'node';
  static const String getNodeDetails = 'user/:userId/node/:nodeId';
  static const String updateMappedNodeUpdate = 'user/:userId/controller/:controllerId/node/:nodeId';
  static const String updateNodeUpdate = 'user/:userId/node/:nodeId';
  static const String deleteNodeDetails = 'user/:userId/node/:nodeId';
  static const String getNodeList = 'user/:userId/controller/:controllerId/nodeUnMapList';
  static const String getSingleNodeNodeList = 'user/:userId/controller/:controllerId/node/:nodeId';
  static const String addMappedNodeList = 'user/:userId/controller/:controllerId/node';
  static const String unMappedNodeDetails = 'user/:userId/controller/:controllerId/node/:nodeId?';
  static const String getNode = 'user/:userId/node';
  static const String getNodesList = 'user/:userId/subuser/:subuserId/controller/:controllerId/valve/status';
  static const String getValveListForProgram = 'user/:userId/subuser/:subuserId/controller/:controllerId/program/:programId/node';

  //TODO: LIVE STATUS URLs
  static const String getLiveStatus = 'user/:userId/subuser/:subuserId/controller/:controllerId/call/:call/livestatus';
  static const String stopLiveStatus = 'user/:userId/subuser/:subuserId/controller/:controllerId/livestatus/stop';
  static const String getLiveUpdate = 'user/:userId/subuser/:subuserId/controller/:controllerId';

  //TODO: ZONE LIST URLs
  static const String getZoneList = 'user/:userId/subuser/:subuserId/controller/:controllerId/zonelistv2';
  static const String getValveListStandalone = 'user/:userId/subuser/:subuserId/controller/:controllerId/nodeliststandalone';

  //TODO: COMMON SETTINGS URLs
  static const String getCommonSetting = 'user/:userId/subuser/:subuserId/controller/:controllerId/commonsettings';
  static const String putCommonSetting = 'user/:userId/subuser/:subuserId/controller/:controllerId/commonsettings';
  static const String resetCommonSetting = 'user/:userId/subuser/:subuserId/controller/:controllerId/commonsettings';

  //TODO: SETTINGS MENU URLs
  static const String getSettingsMenu = 'user/:userId/subuser/:subuserId/controller/:controllerId/menu/:menuId/settings';
  static const String getNotificationSettings = 'user/:userId/subuser/:subuserId/controller/:controllerId/message';
  static const String getFinalMenu = 'user/:userId/subuser/:subuserId/controller/:controllerId/menu/:referenceId/settings/:menuId';
  static const String addViewType4 = 'user/:userId/subuser/:subuserId/controller/:controllerId/menu/:referenceId/settings';
  static const String menuHide = 'user/:userId/subuser/:shareUserId/controller/:controllerId/menu/:menuId/hidemenu';
  static const String menuUnHide = 'user/:userId/subuser/:shareUserId/controller/:controllerId/menu/:menuId/hidemenu';

  //TODO: DND AND MODE URLs
  static const String getDNDStatus = 'user/:userId/subuser/:subuserId/controller/:userDeviceId/dndstatus';
  static const String getOperationStatus = 'user/:userId/subuser/:subuserId/controller/:userDeviceId/mode';

  //TODO: PROGRAM NAME URLs
  static const String getProgramNameList = 'user/:userId/controller/:controllerId/programs';
  static const String updateProgramName = 'user/:userId/subuser/:subuserId/program';

  //TODO: REPLACE URLs
  static const String replaceController = 'user/:userId/subuser/:subuserId/replace';
  static const String replaceController1 = 'productrep';

  //TODO: ZONE SET URL
  static const String getZoneSet = 'user/:userId/subuser/:shareUserId/controller/:controllerId/zoneset/:programId';

  //TODO: SERVICE REQUEST URLs
  static const String createService = 'user/:userId/subuser/:shareUserId/servicerequest/';
  static const String deviceReplaceTraceDealer = 'user/:userId/subuser/:subuserId/controller/:deviceId/deviceId/:userDeviceId/replace';
  static const String deviceReplaceTraceDealer1 = 'productrep/traceProductnew/:traceId';
  static const String updateService = 'user/:userId/dealer/servicerequest/';
  static const String getServiceRequestList = 'user/:userId/servicerequest';

  //TODO: CHAT URLs
  static const String getDealerChatListApi = 'user/:userId/dealer/list';
  static const String getChatListApi = 'user/:userId/fromUser/:fromUserId/chat/:chatFlag';
  static const String sendChatMessageApi = 'user/:userId/dealer/:dealerId/message';
  static const String getChatMessageApi = 'user/:userId/receiver/:dealerId/chat';
  static const String getDealerListApi = 'admin/:userId/dealer/list';
  static const String getDealerCallListApi = 'user/:userId/dealer/call';

  //TODO: FAULT MESSAGES URLs
  static const String addFaultSms = 'user/:userId/subuser/:subUserId/controller/messages/';
  static const String getFaultMessageList = 'user/:userId/subuser/:subUserId/controller/:controllerId/messages/';

  //TODO: VIEW MESSAGES URLs
  static const String viewStatus = 'user/:userId/subuser/:subuserId/controller/:controllerId/view/messages/';
  static const String viewResendStatus = 'user/:userId/subuser/:subuserId/controller/:controllerId/view/resend/messages/';

  //TODO: MQTT URL
  static const String addMqttSms = 'controller/messages/';

  //TODO: TRACE URL
  static const String getTrace = '/';

  //TODO: MOBILE TRACE URL
  static const String getMobileNumberTrace = 'user/:userId/mobileNumber/:mobileNumber/type/:userType/username';

  //TODO: DASHBOARD URLS (Additional from partial)
  static const String dashboardForGroupUrl = 'controller/user/:userId/cluster';
  static const String dashboardUrl = 'user/:userId/cluster/:groupId/controller';
}

// Simple utility function for basic replacement.
String buildUrl(String urlTemplate, Map<String, String> params) {
  String url = urlTemplate;
  for (final entry in params.entries) {
    url = url.replaceAll(':${entry.key}', entry.value);
  }
  return url;
}

// Optional: Add query params if your URL ends with '?'.
String buildUrlWithQuery(String urlTemplate, Map<String, String> pathParams, Map<String, String>? queryParams) {
  String url = buildUrl(urlTemplate, pathParams);
  if (queryParams != null && queryParams.isNotEmpty) {
    final queryString = queryParams.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    url += (url.contains('?') ? '&' : '?') + queryString;
  }
  return url;
}