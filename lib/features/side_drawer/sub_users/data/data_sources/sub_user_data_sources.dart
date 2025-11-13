import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/data/model/sub_user_details_model.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/data/model/sub_user_model.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/entities/sub_user_details_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/usecases/get_sub_user_details_usecase.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/api_client.dart';
import '../../../../../core/utils/api_urls.dart';
import '../../domain/entities/sub_user_entity.dart';

abstract class SubUserDataSources {
  Future<List<SubUserEntity>> getSubUsers(int userId);
  Future<SubUserDetailsEntity> getSubUserDetails(GetSubUserDetailsParams subUserDetailParams);
  Future<String> updateSubUserDetails(SubUserDetailsEntity subUserDetailsEntity);
}

class SubUserDataSourceImpl extends SubUserDataSources {
  final ApiClient apiClient;
  SubUserDataSourceImpl({required this.apiClient});

  @override
  Future<List<SubUserEntity>> getSubUsers(int userId) async {
    try {
      final endpoint = ApiUrls.getSubUserList.replaceAll(':userId', userId.toString());
      final response = await apiClient.get(endpoint);
      if (response['code'] == 200) {
        final List<dynamic> dataList = response['data']['subUserList'];
        final List<SubUserModel> parsedGroups = dataList.map((json) => SubUserModel.fromJson(json as Map<String, dynamic>)).toList();
        return parsedGroups.cast<SubUserEntity>();
      } else {
        throw ServerException(
          statusCode: response['code'],
          message: response['message'],
        );
      }
    } catch (e) {
      print('getSubUsers error: $e');
      throw Exception('Failed to get SubUsers: $e');
    }
  }

  @override
  Future<SubUserDetailsEntity> getSubUserDetails(GetSubUserDetailsParams subUserDetailsParams) async {
    try {
        final endpoint = ApiUrls.getSubUserDetails
            .replaceAll(':userId', subUserDetailsParams.userId.toString())
            .replaceAll(':mSubUserCode', subUserDetailsParams.subUserCode.toString());
      final response = await apiClient.get(endpoint);
      if (response['code'] == 200) {
        final Map<String, dynamic> data = response['data'];
        return SubUserDetailsModel.fromJson(data);
      } else {
        throw ServerException(
          statusCode: response['code'],
          message: response['message'],
        );
      }
    } catch (e, s) {
      print('getSubUserDetails error: $e');
      print('getSubUserDetails stack trace: $s');
      throw Exception('Failed to get Sub User Details: $e');
    }
  }

  @override
  Future<String> updateSubUserDetails(SubUserDetailsEntity subUserDetailsEntity) async {
    try {
      final endpoint = ApiUrls.updateSubUserDetails;
      final subUserDetail = subUserDetailsEntity.subUserDetail;

      final selectedControllers = subUserDetailsEntity.controllerList
          .where((controller) => controller.shareFlag == 1)
          .toList();

      final controllerListData = selectedControllers.map((controller) => {
        'userDeviceId': controller.userDeviceId,
        'dndStatus': controller.dndStatus,
        'eSms': 'REG01,${subUserDetail.mobileCountryCode},${subUserDetail.mobileNumber}',
        'dndSms': 'DNDSMS,${controller.shareFlag},${controller.dndStatus}',
      }).toList();

      final reqBody = {
        'shareUserId': subUserDetail.sharedUserId,
        'subUserId': subUserDetail.subuserId,
        'userId': 2558,
        'subUserCode': subUserDetail.subUserCode,
        'userName': subUserDetail.userName,
        'mobileNumber': subUserDetail.mobileNumber,
        'mobileCountryCode': subUserDetail.mobileCountryCode,
        'controllerList': controllerListData,
      };

      print("reqBody :: $reqBody");
      final response = await apiClient.put(endpoint, body: reqBody);
      print("response in the updateSubUserDetails :: ${response['message']}");
      if (response['code'] == 200) {
        return response['message'] ?? 'Update successful';
      } else {
        throw ServerException(
          statusCode: response['code'],
          message: response['message'],
        );
      }
    } catch (e, s) {
      print('updateSubUserDetails error: $e');
      print('updateSubUserDetails stack trace: $s');
      throw Exception('Failed to get Sub User Details: $e');
    }
  }
}