import 'dart:developer';

import '../../domain/entities/menu_item_entity.dart';
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
              "TID": 4581,
              "NAME": "VOLTAGE CALIBRATION",
              "SETS": [
                {
                  "SN": 1,
                  "WT": 7,
                  "VAL": "0 ; 0 ; 0",
                  "SF": "VOLTCAL",
                  "TT": "VR ; VY ; VB",
                  "HF": "1"
                },
                {
                  "SN": 2,
                  "WT": 7,
                  "VAL": "0.00 ; 0.00 ; 0.00",
                  "SF": "VOLTAGCAL",
                  "TT": "",
                  "HF": "1"
                }
              ]
            },
            {
              "TID": 4582,
              "NAME": "CURRENT CALIBRATION",
              "SETS": [
                {
                  "SN": 1,
                  "WT": 7,
                  "VAL": "0 ; 0 ; 0",
                  "SF": "CURCAL",
                  "TT": "CURRENT CALIBRATION",
                  "HF": "1"
                },
                {
                  "SN": 2,
                  "WT": 7,
                  "VAL": "0.00 ; 0.00 ; 0.00",
                  "SF": "CURRENTCAL",
                  "TT": "",
                  "HF": "1"
                }
              ]
            },
            {
              "TID": 4583,
              "NAME": "POWER FACTOR",
              "SETS": [
                {
                  "SN": 1,
                  "WT": 2,
                  "VAL": "OF",
                  "SF": "PFCSET",
                  "TT": "PF CORRECTION SCAN",
                  "HF": "1"
                },
                {
                  "SN": 2,
                  "WT": 3,
                  "VAL": "00:00:00",
                  "SF": "POSCDDELAY",
                  "TT": "PF CORRECTION TIMER",
                  "HF": "1"
                },
                {
                  "SN": 3,
                  "WT": 1,
                  "VAL": "000",
                  "SF": "PFCVOLT",
                  "TT": "PF VOLT",
                  "HF": "1"
                }
              ]
            },
            {
              "TID": 4584,
              "NAME": "CURRENT SENSING R-Y-B",
              "SETS": [
                {
                  "SN": 1,
                  "WT": 2,
                  "VAL": "OF",
                  "SF": "CTR",
                  "TT": "R SCAN",
                  "HF": "1"
                },
                {
                  "SN": 2,
                  "WT": 2,
                  "VAL": "OF",
                  "SF": "CTY",
                  "TT": "Y SCAN",
                  "HF": "1"
                },
                {
                  "SN": 3,
                  "WT": 2,
                  "VAL": "OF",
                  "SF": "CTB",
                  "TT": "B SCAN",
                  "HF": "1"
                }
              ]
            },
            {
              "TID": 4585,
              "NAME": "OTHERS",
              "SETS": [
                {
                  "SN": 1,
                  "WT": 2,
                  "VAL": "OF",
                  "SF": "CTCURRENTSPP",
                  "TT": "CURRENT SPP SCAN",
                  "HF": "1"
                },
                {
                  "SN": 2,
                  "WT": 2,
                  "VAL": "OF",
                  "SF": "DOUBLEPUMP",
                  "TT": "DUAL PUMP",
                  "HF": "1"
                },
                {
                  "SN": 3,
                  "WT": 7,
                  "VAL": "0 ; 0",
                  "SF": "SETMAXLEVEL",
                  "TT": "MIN ; MAX",
                  "HF": "1"
                },
                {
                  "SN": 4,
                  "WT": 2,
                  "VAL": "CURRENTCAL/VOLTAGCAL",
                  "SF": "CTY",
                  "TT": "WIRELESS",
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