import 'package:logger/logger.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/data/model/sub_user_details_model.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/data/model/sub_user_model.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/entities/sub_user_details_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/usecases/get_sub_user_by_phone_usecase.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/usecases/get_sub_user_details_usecase.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/usecases/update_sub_user_usecase.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/api_client.dart';
import '../../../../../core/utils/api_helper.dart';
import '../../../../../core/utils/api_urls.dart';
import '../../domain/entities/sub_user_entity.dart';

abstract class SubUserDataSources {
  Future<List<SubUserEntity>> getSubUsers(int userId);
  Future<SubUserDetailsEntity> getSubUserDetails(GetSubUserDetailsParams subUserDetailParams);
  Future<String> updateSubUserDetails(UpdateSubUserDetailsParams updateSubUserDetailsParams);
  Future<dynamic> getSubUserByPhone(GetSubUserByPhoneParams geSubUserByPhoneParams);
}

class SubUserDataSourceImpl extends SubUserDataSources {
  final ApiClient apiClient;
  final Logger logger;
  SubUserDataSourceImpl({required this.apiClient, required this.logger});

  @override
  Future<List<SubUserEntity>> getSubUsers(int userId) async {
    try {
      final endpoint = ApiUrls.getSubUserList.replaceAll(':userId', userId.toString());
      final response = await safeApiCall(() => apiClient.get(endpoint));
      // safeApiCall already throws on non-200, so just parse
      final List<dynamic> dataList = response['data']['subUserList'];
      return dataList.map((json) => SubUserModel.fromJson(json as Map<String, dynamic>)).cast<SubUserEntity>().toList();
    } on FormatException catch (e) {  // e.g., Bad JSON
      logger.e('JSON parse error in getSubUsers: $e');
      throw UnexpectedException('Failed to parse sub-users data: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SubUserDetailsEntity> getSubUserDetails(GetSubUserDetailsParams subUserDetailsParams) async {
    try {
      String endpoint = ApiUrls.getSubUserDetails
          .replaceAll(':userId', subUserDetailsParams.userId.toString())
          .replaceAll(':mSubUserCode', subUserDetailsParams.subUserCode.toString());
      if (subUserDetailsParams.isNewSubUser) {
        endpoint = ApiUrls.getControllerList.replaceAll(':userId', subUserDetailsParams.userId.toString());
      }
      final response = await safeApiCall(() => apiClient.get(endpoint));
      if (subUserDetailsParams.isNewSubUser) {
        final List<dynamic> controllerData = response['controllerList'];
        return SubUserDetailsModel(
            subUserDetail: SubUserModel(
                userName: '',
                mobileCountryCode: '',
                mobileNumber: '',
                sharedUserId: '',
                subUserCode: subUserDetailsParams.subUserCode,
                subuserId: ''
            ),
            controllerList: controllerData.map((e) => SubUserControllerModel.fromJson(e as Map<String, dynamic>)).toList()
        );
      } else {
        final Map<String, dynamic> data = response['data'];
        return SubUserDetailsModel.fromJson(data);
      }
    } on FormatException catch (e, s) {
      logger.e('JSON parse error in getSubUserDetails: $e', error: e, stackTrace: s);
      throw UnexpectedException('Failed to parse sub-user details: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateSubUserDetails(UpdateSubUserDetailsParams updateSubUserDetailsParams) async {
    final subUserDetail = updateSubUserDetailsParams.subUserDetailsEntity.subUserDetail;
    final selectedControllers = updateSubUserDetailsParams.subUserDetailsEntity.controllerList
        .where((controller) => controller.shareFlag == 1)
        .toList();

    try {
      final endpoint = ApiUrls.addSubUser;
      if (updateSubUserDetailsParams.isNewSubUser) {
        final controllerListData = selectedControllers.map((controller) => {
          'userDeviceId': controller.userDeviceId,
          'sms': '${subUserDetail.subUserCode},${subUserDetail.mobileCountryCode},${subUserDetail.mobileNumber},',
        }).toList();

        final reqBody = {
          'subUserId': subUserDetail.subuserId.toString(),
          'userId': updateSubUserDetailsParams.userId.toString(),
          'subUserCode': subUserDetail.subUserCode,
          'dndStatus': 1,
          'controllerList': controllerListData,
        };

        final response = await safeApiCall(() => apiClient.post(endpoint, body: reqBody));
        return response['message'] ?? 'Update successful';  // safeApiCall ensures 200
      } else {
        final controllerListData = selectedControllers.map((controller) => {
          'userDeviceId': controller.userDeviceId,
          'dndStatus': controller.dndStatus,
          'eSms': '${subUserDetail.subUserCode},${subUserDetail.mobileCountryCode},${subUserDetail.mobileNumber}',
          'dndSms': 'DNDSMS,${controller.shareFlag},${controller.dndStatus}',
        }).toList();

        final reqBody = {
          'shareUserId': subUserDetail.sharedUserId,
          'subUserId': subUserDetail.subuserId,
          'userId': updateSubUserDetailsParams.userId,
          'subUserCode': subUserDetail.subUserCode,
          'userName': subUserDetail.userName,
          'mobileNumber': subUserDetail.mobileNumber,
          'mobileCountryCode': subUserDetail.mobileCountryCode,
          'controllerList': controllerListData,
        };

        logger.d('Request body for update: $reqBody');  // Optional debug log
        final response = await safeApiCall(() => apiClient.put(endpoint, body: reqBody));
        logger.i('Update response: ${response['message']}');
        return response['message'] ?? 'Update successful';
      }
    } on FormatException catch (e) {
      // logger?.e('JSON parse error in updateSubUserDetails: $e');
      throw UnexpectedException('Failed to parse update response: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getSubUserByPhone(GetSubUserByPhoneParams geSubUserByPhoneParams) async {
    try {
      final endpoint = ApiUrls.getSubUSer.replaceAll(':mobileno', geSubUserByPhoneParams.phoneNumber);
      final response = await safeApiCall(() => apiClient.get(endpoint));
      logger.d('Response for phone lookup: $response');  // Optional
      return response['data'];
    } on FormatException catch (e) {
      logger.e('JSON parse error in getSubUserByPhone: $e');
      throw UnexpectedException('Failed to parse phone lookup data: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}