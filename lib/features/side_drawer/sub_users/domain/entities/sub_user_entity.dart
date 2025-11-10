class SubUserEntity {
  final dynamic sharedUserId;
  final String userName;
  final String mobileNumber;
  final String mobileCountryCode;
  final String subUserCode;

  SubUserEntity({
    required this.userName,
    required this.mobileCountryCode,
    required this.mobileNumber,
    required this.sharedUserId,
    required this.subUserCode
  });
}