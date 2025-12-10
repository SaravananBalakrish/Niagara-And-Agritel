import 'dart:developer';

import 'package:niagara_smart_drip_irrigation/features/pump_settings/domain/entities/menu_item_entity.dart';

import '../models/menu_item_model.dart';
import '../models/settings_menu_model.dart';
import '../../utils/pump_settings_urls.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../domain/entities/settings_menu_entity.dart';

import '../../../../core/services/api_client.dart';

abstract class PumpSettingsDataSources {
  Future<List<SettingsMenuEntity>> getSettingsMenuList(int userId, int subUserId, int controllerId);
  Future<MenuItemEntity> getPumpSettings(int userId, int subUserId, int controllerId, int menuId);
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

  @override
  Future<MenuItemEntity> getPumpSettings(
      int userId, int subUserId, int controllerId, int menuId) async {
    try {
      final endpoint = PumpSettingsUrls.getFinalMenu
          .replaceAll(':userId', userId.toString())
          .replaceAll(':subUserId', '0')
          .replaceAll(':controllerId', controllerId.toString())
          .replaceAll(':referenceId', '91')
          .replaceAll(':menuId', menuId.toString());

      final response = await apiClient.get(endpoint);
      // print("response :: $response");

      return handleApiResponse<MenuItemEntity>(
        response,
        parser: (dynamic data) {
          Map<String, dynamic> jsonMap;

          if (data is List) {
            if (data.isEmpty) {
              throw ServerException(message: "No menu item found");
            }
            jsonMap = data.first as Map<String, dynamic>;
          } else if (data is Map<String, dynamic>) {
            jsonMap = data;
          } else {
            throw ServerException(message: "Invalid data format");
          }

          final staticJson = [
            {
              "TID": 4521,
              "NAME": "Cyclic Timer Settings",
              "SETS": [
                {
                  "SN": 1,
                  "WT": 2,
                  "VAL": "OF",
                  "SF": "CYCLIC",
                  "TT": "Cyclic Timer",
                  "HF": "1"
                },
                {
                  "SN": 2,
                  "WT": 4,
                  "VAL": "00:00:00 ; 00:00:00",
                  "SF": "CYCLICTIMONOF",
                  "TT": "On Time ; Off Time",
                  "HF": "1"
                },
                {
                  "SN": 3,
                  "WT": 2,
                  "VAL": "OF",
                  "SF": "CYCLICCHOVR",
                  "TT": "Change Over",
                  "HF": "1"
                },
                {
                  "SN": 4,
                  "WT": 4,
                  "VAL": "00:00:00 ; 00:00:00 ; 00:00:00",
                  "SF": "CYCLICTIMONOF",
                  "TT": "Motor 1 On Time ; Motor 2 On Time ; Off Time",
                  "HF": "1"
                }
              ]
            },
            {
              "TID": 4522,
              "NAME": "Dry Run Restart Timer",
              "SETS": [
                {
                  "SN": 1,
                  "WT": 2,
                  "VAL": "OF",
                  "SF": "DRRESTARTTIM",
                  "TT": "Dry Run Restart Timer",
                  "HF": "1"
                },
                {
                  "SN": 2,
                  "WT": 4,
                  "VAL": "00:00:00 ; 00:00:00",
                  "SF": "DRRESTARTTIM",
                  "TT": "Motor 1 ; Motor 2",
                  "HF": "1"
                }
              ]
            },
            {
              "TID": 4523,
              "NAME": "Maximum Runtime Settings",
              "SETS": [
                {
                  "SN": 1,
                  "WT": 2,
                  "VAL": "OF",
                  "SF": "MAXTIM",
                  "TT": "Maximum Runtime",
                  "HF": "1"
                },
                {
                  "SN": 2,
                  "WT": 3,
                  "VAL": "00:00:00",
                  "SF": "MAXTIM",
                  "TT": "Delay Timer",
                  "HF": "1"
                }
              ]
            },
            {
              "TID": 4524,
              "NAME": "Night Light RTC Settings",
              "SETS": [
                {
                  "SN": 1,
                  "WT": 2,
                  "VAL": "OF",
                  "SF": "NIGHTLIGHTRTC",
                  "TT": "Night Light RTC",
                  "HF": "1"
                },
                {
                  "SN": 1,
                  "WT": 5,
                  "VAL": "00:00 ; 00:00",
                  "SF": "NIGHTLIGHTRTCTIM",
                  "TT": "From ; To",
                  "HF": "1"
                }
              ]
            },
            {
              "TID": 4525,
              "NAME": "RTC Timer Settings",
              "SETS": [
                {
                  "SN": 1,
                  "WT": 2,
                  "VAL": "OF",
                  "SF": "RTC",
                  "TT": "RTC Timer",
                  "HF": "1"
                },
                {
                  "SN": 2,
                  "WT": 4,
                  "VAL": "00:00:00 ; 00:00:00",
                  "SF": "RTCTIMONOF1",
                  "TT": "On Time ; Off Time",
                  "HF": "1"
                },
                {
                  "SN": 3,
                  "WT": 4,
                  "VAL": "00:00:00 ; 00:00:00",
                  "SF": "RTCTIMONOF2",
                  "TT": "On Time ; Off Time",
                  "HF": "1"
                },
                {
                  "SN": 4,
                  "WT": 4,
                  "VAL": "00:00:00 ; 00:00:00",
                  "SF": "RTCTIMONOF3",
                  "TT": "On Time ; Off Time",
                  "HF": "1"
                },
                {
                  "SN": 5,
                  "WT": 4,
                  "VAL": "00:00:00 ; 00:00:00",
                  "SF": "RTCTIMONOF4",
                  "TT": "On Time ; Off Time",
                  "HF": "1"
                }
              ]
            }
          ];
          return MenuItemModel.fromJson(jsonMap, staticJson);
        },
      ).fold(
            (failure) => throw ServerException(message: failure.message),
            (menuItem) => menuItem,
      );
    } catch (e, s) {
      log('getPumpSettings error :: $e');
      log('getPumpSettings stacktrace :: $s');
      rethrow;
    }
  }
}