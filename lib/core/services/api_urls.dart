class ApiUrls {
  static const String commonUrl = '/api/v1';
  static const String verifyUserUrl = '$commonUrl/verifyUser';
  static const String loginWithPasswordUrl = '$commonUrl/signin';
  static const String loginWithOtpUrl = '$commonUrl/signin1';
  static const String signUp = '$commonUrl/signUp';
  static const String editProfile = '$commonUrl/editProfile';
  static const String dashboardForGroupUrl = '$commonUrl/controller/user/:userId/cluster';
  static const String dashboardUrl = '$commonUrl/user/:userId/cluster/:groupId/controller';
  static const String pumpSettingsUrl = '$commonUrl/user/:userId/subuser/0/controller/6946/menu/91/settings';
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