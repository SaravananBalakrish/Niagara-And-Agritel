// features/pump_settings/domain/entities/template_json_entity.dart

class TemplateJsonEntity {
  final String type;
  final List<ParameterGroupEntity> groups;
  final List<SettingSectionEntity> sections;

  const TemplateJsonEntity({
    required this.type,
    required this.groups,
    required this.sections
  });
}

class ParameterGroupEntity {
  final String groupName; // e.g. "Dry Run Settings", "LOW VOLT"
  final List<ParameterItemEntity> items;

  const ParameterGroupEntity({
    required this.groupName,
    required this.items,
  });
}

class ParameterItemEntity {
  // Common
  final String? toggleType;
  final String? toggleStatus;
  final String? delayTime;
  final String? onTime;
  final String? offTime;
  final String? timeValue;
  final String? numberValue;
  final String? fromValue;
  final String? toValue;
  final String? progNumber;

  // Voltage Settings
  final String? phaseValue;
  final String? voltageValue;
  final String? voltageDifferenceValue;
  final String? voltagePlaceHolder;
  final String? differencePlaceHolder;

  // Current Settings (Dry Run / Overload)
  final String? phase2Value;
  final String? phase3Value;

  const ParameterItemEntity({
    this.toggleType,
    this.toggleStatus,
    this.delayTime,
    this.onTime,
    this.offTime,
    this.timeValue,
    this.numberValue,
    this.fromValue,
    this.toValue,
    this.progNumber,
    this.phaseValue,
    this.voltageValue,
    this.voltageDifferenceValue,
    this.voltagePlaceHolder,
    this.differencePlaceHolder,
    this.phase2Value,
    this.phase3Value,
  });
}

class SettingsEntity {
  final int serialNumber;
  final int widgetType;
  final String value;
  final String smsFormat;
  final String title;
  final String hiddenFlag;

  SettingsEntity({
    required this.serialNumber,
    required this.widgetType,
    required this.value,
    required this.smsFormat,
    required this.title,
    required this.hiddenFlag,
  });
}

class SettingSectionEntity {
  final int typeId;
  final String sectionName;
  final List<SettingsEntity> settings;

  SettingSectionEntity({
    required this.typeId,
    required this.sectionName,
    required this.settings,
  });
}