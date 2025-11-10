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
}