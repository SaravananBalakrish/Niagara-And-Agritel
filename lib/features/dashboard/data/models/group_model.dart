import '../../domain/entities/group_entity.dart';

class GroupDetails extends GroupDetailsEntity{
  GroupDetails({
    required super.userGroupId,
    required super.userId,
    required super.groupName,
  });

  factory GroupDetails.fromJson(Map<String, dynamic> json) {
    return GroupDetails(
      userGroupId: json['userGroupId'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      groupName: json['groupName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userGroupId': userGroupId,
      'userId': userId,
      'groupName': groupName,
    };
  }

  GroupDetailsEntity toEntity() {
    return GroupDetailsEntity(
      userGroupId: userGroupId,
      userId: userId,
      groupName: groupName,
    );
  }
}