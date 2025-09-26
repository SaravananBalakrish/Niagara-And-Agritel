class ApiUrls {
  static const String commonUrl = '/api/v1';
  static const String verifyUserUrl = '$commonUrl/verifyUser';
  static const String loginUrl = '$commonUrl/signin';
  static const String dashboardForGroupUrl = '$commonUrl/controller/user/:userId/cluster';
  static const String dashboardUrl = '$commonUrl/user/:userId/cluster/:groupId/controller';
}

/*login => post ==> /api/v1/signin
{
    "mobileNumber" : mobileNumber,
    "password"     : passwordHash,
    "deviceToken"  : "",
    "macAddress"   : ipaddress
}

/api/v1/verifyUser  => countryCode, mobileNumber
dashboard =>
for get group => get ==> /api/v1/controller/user/:userId/cluster
get dashboard => get ==> /api/v1/user/:userId/cluster/:groupId/controller
*/