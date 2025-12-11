import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/action_button.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/alert_dialog.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glass_effect.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glassy_wrapper.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/retry.dart';
import 'package:niagara_smart_drip_irrigation/core/services/time_picker_service.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/domain/entities/menu_item_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/cubit/pump_settings_cubit.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/widgets/setting_list_tile.dart';

import '../../../../core/di/injection.dart' as di;
import '../../domain/entities/setting_widget_type.dart';
import '../../domain/entities/template_json_entity.dart';
import '../bloc/pump_settings_state.dart';

class PumpSettingsPage extends StatelessWidget {
  final int userId, subUserId, controllerId, menuId;
  final String? menuName;

  const PumpSettingsPage({
    super.key,
    required this.userId,
    required this.subUserId,
    required this.controllerId,
    required this.menuId,
    this.menuName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<PumpSettingsCubit>()
        ..loadSettings(
          userId: userId,
          subUserId: subUserId,
          controllerId: controllerId,
          menuId: menuId,
        ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(menuName ?? 'Pump Settings')),
        body: GlassyWrapper(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (n) {
              n.disallowIndicator();
              return true;
            },
            child: BlocBuilder<PumpSettingsCubit, PumpSettingsState>(
              builder: (context, state) {
                if (state is GetPumpSettingsInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is GetPumpSettingsLoaded) {
                  return _SettingsList(menu: state.settings);
                }
                if (state is GetPumpSettingsError) {
                  return Center(
                    child: Retry(
                      message: state.message,
                      onPressed: () => context.read<PumpSettingsCubit>().loadSettings(
                        userId: userId,
                        subUserId: subUserId,
                        controllerId: controllerId,
                        menuId: menuId,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  final MenuItemEntity menu;
  const _SettingsList({required this.menu});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: menu.template.sections.length,
      itemBuilder: (context, sectionIndex) {
        final section = menu.template.sections[sectionIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(section.sectionName, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...section.settings.map((setting) => _SettingRow(
              setting: setting,
              sectionIndex: sectionIndex,
              settingIndex: section.settings.indexOf(setting),
            )),
          ],
        );
      },
    );
  }
}

class _SettingRow extends StatelessWidget {
  final SettingsEntity setting;
  final int sectionIndex;
  final int settingIndex;

  const _SettingRow({
    required this.setting,
    required this.sectionIndex,
    required this.settingIndex,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PumpSettingsCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: GlassCard(padding: EdgeInsets.zero, child: _buildInput(context))),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
              onPressed: () => cubit.sendCurrentSetting(sectionIndex, settingIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return switch (setting.widgetType) {
      SettingWidgetType.phone => _PhoneInput(setting: setting, onChanged: _onChanged(context)),
      SettingWidgetType.multiTime => _MultiTimeInput(setting: setting, onChanged: _onChanged(context)),
      SettingWidgetType.fullText => _TextInput(setting: setting, onChanged: _onChanged(context)),
      _ => SettingListTile(
        title: setting.title,
        trailing: _buildTrailing(context),
        onTap: () => _handleTap(context),
      ),
    };
  }

  Widget _buildTrailing(BuildContext context) {
    return switch (setting.widgetType) {
      SettingWidgetType.text => Text(setting.value.isEmpty ? "-" : setting.value, style: Theme.of(context).textTheme.bodyMedium,),
      SettingWidgetType.toggle => Switch(
        value: setting.value == "ON",
        onChanged: (_) => _onChanged(context)(setting.value == "ON" ? "OF" : "ON"),
      ),
      SettingWidgetType.time => Text(setting.value.isEmpty ? "00:00" : setting.value, style: Theme.of(context).textTheme.bodyMedium),
      _ => Text(setting.value, style: Theme.of(context).textTheme.bodyMedium),
    };
  }

  void Function(String newValue) _onChanged(BuildContext context) {
    return (String newValue) {
      context.read<PumpSettingsCubit>().updateSettingValue(
        newValue,
        sectionIndex,
        settingIndex,
      );
    };
  }

  void _handleTap(BuildContext context) async {
    String? newValue;

    switch (setting.widgetType) {
      case SettingWidgetType.text:
        newValue = await _showTextDialog(context);
        break;

      case SettingWidgetType.toggle:
        newValue = setting.value == "OF" ? "ON" : "OF";
        break;

      case SettingWidgetType.time:
        newValue = await TimePickerService.show(
          context: context,
          title: setting.title,
          initialTime: setting.value,
        );
        break;

      default:
        return;
    }

    if (newValue != null && newValue != setting.value) {
      _onChanged(context)(newValue);
    }
  }

  Future<String?> _showTextDialog(BuildContext context) async {
    final controller = TextEditingController(text: setting.value);
    return GlassyAlertDialog.show<String>(
      context: context,
      title: setting.title,
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        onTap: () => controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length),
      ),
      actions: [
        ActionButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ActionButton(
          isPrimary: true,
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: const Text("Save"),
        ),
      ],
    );
  }
}

class _PhoneInput extends StatelessWidget {
  final SettingsEntity setting;
  final ValueChanged<String> onChanged;
  const _PhoneInput({required this.setting, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      initialValue: setting.value,
      initialCountryCode: 'IN',
      style: const TextStyle(color: Colors.white),
      dropdownTextStyle: const TextStyle(color: Colors.white),
      dropdownIcon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      onChanged: (phone) => onChanged(phone.completeNumber),
    );
  }
}

class _TextInput extends StatelessWidget {
  final SettingsEntity setting;
  final ValueChanged<String> onChanged;
  const _TextInput({required this.setting, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: setting.value,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: setting.title,
          contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 10)
      ),
      onChanged: onChanged,
    );
  }
}

class _MultiTimeInput extends StatelessWidget {
  final SettingsEntity setting;
  final ValueChanged<String> onChanged;
  const _MultiTimeInput({required this.setting, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final titles = setting.title.split(';').map((e) => e.trim()).toList();
    final values = setting.value.split(';').map((e) => e.trim()).toList();

    return Column(
      children: List.generate(titles.length, (i) => SettingListTile(
        title: titles[i],
        trailing: Text(values[i], style: Theme.of(context).textTheme.bodyMedium,),
        onTap: () async {
          final newTime = await TimePickerService.show(context: context, title: titles[i], initialTime: values[i]);
          if (newTime != null) {
            final newValues = [...values]..[i] = newTime;
            onChanged(newValues.join(';'));
          }
        },
      )),
    );
  }
}