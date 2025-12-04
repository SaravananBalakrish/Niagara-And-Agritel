import 'dart:convert';

import 'package:niagara_smart_drip_irrigation/features/pump_settings/data/models/settings_menu_model.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/data/models/template_json_model.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/domain/entities/menu_item_entity.dart';

class MenuItemModel extends MenuItemEntity {
  MenuItemModel({
    required super.settingsMenuEntity,
    required super.templateJsonEntity,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json, List<Map<String, dynamic>> staticJson) {
    print("json in the MenuItemModel :: $json");
    return MenuItemModel(
        settingsMenuEntity: SettingsMenuModel.fromJson(json),
        templateJsonEntity: TemplateJsonModel.fromJson(jsonDecode(json['templateJson']), staticJson)
    );
  }
}