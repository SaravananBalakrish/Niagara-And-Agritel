import 'package:niagara_smart_drip_irrigation/features/pump_settings/domain/entities/settings_menu_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/domain/entities/template_json_entity.dart';

class MenuItemEntity {
  final SettingsMenuEntity settingsMenuEntity;
  final TemplateJsonEntity templateJsonEntity;
  MenuItemEntity({
    required this.settingsMenuEntity,
    required this.templateJsonEntity
  });
}