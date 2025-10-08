import '../../../../core/services/api_client.dart';
import '../../../../core/services/api_urls.dart';

abstract class DashboardRemoteDataSource {
  Future<dynamic> fetchDashboardGroups(int userId);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;

  DashboardRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<dynamic> fetchDashboardGroups(int userId) async {
    print("userId in the fetchDashboardGroups :: $userId");
    try {
      final endpoint = ApiUrls.dashboardForGroupUrl.replaceAll(':userId', userId.toString());
      final response = await apiClient.get(endpoint);
      print('Dashboard groups API response: $response');
      return response;
    } catch (e) {
      print('Fetch dashboard groups error: $e');
      throw Exception('Failed to fetch dashboard groups: $e');
    }
  }
}