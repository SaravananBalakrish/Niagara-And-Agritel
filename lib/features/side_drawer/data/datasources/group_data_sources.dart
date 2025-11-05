import 'package:niagara_smart_drip_irrigation/features/side_drawer/data/model/group_details.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/domain/entities/group_entity.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/utils/api_urls.dart';

abstract class GroupDataSources {
  Future<List<GroupEntity>> fetchGroups(int userId);
}

class GroupDataSourcesImpl extends GroupDataSources {
  final ApiClient apiClient;
  GroupDataSourcesImpl(this.apiClient);

  @override
  @override
  Future<List<GroupEntity>> fetchGroups(int userId) async {
    print("userId in the fetchGroups :: $userId");
    try {
      final endpoint = ApiUrls.getGroupValues.replaceAll(':userId', userId.toString());
      final response = await apiClient.get(endpoint);
      if (response['code'] == 200) {
        final List<dynamic> dataList = response['data'];
        final List<GroupModel> parsedGroups = dataList.map((json) => GroupModel.fromJson(json as Map<String, dynamic>)).toList();
        return parsedGroups.cast<GroupEntity>();
      } else {
        throw ServerException(
          statusCode: response['code'],
          message: response['message'] ?? 'Group details fetching Error',
        );
      }
    } catch (e) {
      print('Fetch dashboard groups error: $e');
      throw Exception('Failed to fetch dashboard groups: $e');
    }
  }

}