import 'package:niagara_smart_drip_irrigation/features/dashboard/data/models/group_model.dart';
import 'package:niagara_smart_drip_irrigation/features/dashboard/data/models/controller_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/api_urls.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/entities/controller_entity.dart';

abstract class DashboardRemoteDataSource {
  Future<List<GroupDetailsEntity>> fetchDashboardGroups(int userId);
  Future<List<ControllerEntity>> fetchControllers(int userId, int groupId);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;

  DashboardRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<GroupDetailsEntity>> fetchDashboardGroups(int userId) async {
    print("userId in the fetchDashboardGroups :: $userId");
    try {
      final endpoint = ApiUrls.dashboardForGroupUrl.replaceAll(':userId', userId.toString());
      final response = await apiClient.get(endpoint);
      if (response['code'] == 200) {
        final List<dynamic> dataList = response['data'];
        final List<GroupDetails> parsedGroups = dataList.map((json) => GroupDetails.fromJson(json as Map<String, dynamic>)).toList();
        return parsedGroups.cast<GroupDetailsEntity>();
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

  @override
  Future<List<ControllerEntity>> fetchControllers(int userId, int groupId) async {
    print("Fetching controllers for userId: $userId, groupId: $groupId");
    try {
      final endpoint = ApiUrls.dashboardUrl.replaceAll(':userId', userId.toString()).replaceAll(':groupId', groupId.toString());
      final response = await apiClient.get(endpoint);
      if (response['code'] == 200) {
        final List<dynamic> dataList = response['data'];
        final List<ControllerModel> parsedControllers = dataList
            .map((json) => ControllerModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return parsedControllers.cast<ControllerEntity>();
      } else {
        throw ServerException(
          statusCode: response['code'],
          message: response['message'] ?? 'Controllers fetching Error',
        );
      }
    } catch (e, stackTrace) {
      print('Fetch controllers error: $e');
      print('Fetch controllers stack trace: $stackTrace');
      throw Exception('Failed to fetch controllers: $stackTrace');
    }
  }
}