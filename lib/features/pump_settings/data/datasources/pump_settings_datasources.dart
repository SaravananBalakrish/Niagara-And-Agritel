import '../models/settings_menu_model.dart';
import '../../utils/pump_settings_urls.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../domain/entities/settings_menu_entity.dart';

import '../../../../core/services/api_client.dart';

abstract class PumpSettingsDataSources {
  Future<List<SettingsMenuEntity>> getSettingsMenuList(int userId, int subUserId, int controllerId);
}

class PumpSettingsDataSourcesImpl implements PumpSettingsDataSources {
  final ApiClient apiClient;
  PumpSettingsDataSourcesImpl({required this.apiClient});

  @override
  Future<List<SettingsMenuEntity>> getSettingsMenuList(int userId, int subUserId, int controllerId) async{
    try {
      final endpoint = PumpSettingsUrls.getSettingsMenu
          .replaceAll(':userId', userId.toString())
          .replaceAll(':subUserId', '0')
          .replaceAll(':controllerId', controllerId.toString())
          .replaceAll(':referenceId', '91');
      final response = await apiClient.get(endpoint);
      return handleListResponse<SettingsMenuModel>(
        response,
        fromJson: (json) => SettingsMenuModel.fromJson(json),
      ).fold(
            (failure) => throw ServerException(message: failure.message),
            (groups) => groups.cast<SettingsMenuEntity>(),
      );
    } catch (e) {
      rethrow;
    }
  }
}