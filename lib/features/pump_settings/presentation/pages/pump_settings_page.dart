import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/action_button.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glass_effect.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glassy_wrapper.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/retry.dart';
import 'package:niagara_smart_drip_irrigation/core/services/time_picker_service.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/domain/entities/menu_item_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/domain/entities/template_json_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/cubit/pump_settings_cubit.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/widgets/setting_list_tile.dart';

import '../../../../core/di/injection.dart' as di;
import '../../../../core/widgets/alert_dialog.dart';
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
        appBar: AppBar(
          title: Text(menuName ?? 'Pump Settings'),
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: GlassCard(
              padding: EdgeInsets.zero,
              child: _buildSettingContent(context),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
              onPressed: () => _sendSetting(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingContent(BuildContext context) {
    if ([4, 5].contains(setting.widgetType)) {
      final titles = setting.title.split(';').map((e) => e.trim()).toList();
      final values = setting.value.split(';').map((e) => e.trim()).toList();

      return Column(
        children: List.generate(titles.length, (i) {
          return SettingListTile(
            title: titles[i],
            trailing: Text(values[i], style: Theme.of(context).textTheme.bodyMedium),
            onTap: () async {
              final newTime = await TimePickerService.show(
                context: context,
                title: titles[i],
                initialTime: values[i],
              );
              if (newTime == null) return;

              final newValues = [...values]..[i] = newTime;
              final newValue = newValues.join(';');

              if (newValue != setting.value) {
                context.read<PumpSettingsCubit>().updateSettingValue(
                  newValue,
                  sectionIndex,
                  settingIndex,
                );
              }
            },
          );
        }),
      );
    }

    return SettingListTile(
      title: setting.title,
      trailing: _buildTrailing(context),
      onTap: () => _handleTap(context),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    switch (setting.widgetType) {
      case 1:
        return Text(setting.value.isEmpty ? "-" : setting.value);
      case 2:
        final isOn = setting.value == "ON";
        return Switch(
          value: isOn,
          onChanged: (_) {
            final newVal = isOn ? "OF" : "ON";
            context.read<PumpSettingsCubit>().updateSettingValue(newVal, sectionIndex, settingIndex);
          },
        );
      case 3:
        return Text(setting.value.isEmpty ? "00:00:00" : setting.value);
      default:
        return Text(setting.value);
    }
  }

  void _handleTap(BuildContext context) async {
    final cubit = context.read<PumpSettingsCubit>();

    switch (setting.widgetType) {
      case 1:
        final newVal = await _showTextDialog(context, setting.title, setting.value);
        if (newVal != null && newVal != setting.value) {
          cubit.updateSettingValue(newVal, sectionIndex, settingIndex);
        }
        break;

      case 2:
        final newVal = setting.value == "OF" ? "ON" : "OF";
        cubit.updateSettingValue(newVal, sectionIndex, settingIndex);
        break;

      case 3:
        final newTime = await TimePickerService.show(
          context: context,
          title: setting.title,
          initialTime: setting.value,
        );
        if (newTime != null && newTime != setting.value) {
          cubit.updateSettingValue(newTime, sectionIndex, settingIndex);
        }
        break;
    }
  }

  void _sendSetting(BuildContext context) {
    final cleanValue = setting.value.trim();
    final payload = [4, 5].contains(setting.widgetType)
        ? "${setting.smsFormat},$cleanValue"
        : "${setting.smsFormat}$cleanValue";

    final finalPayload = payload
        .replaceAll(':', '')
        .replaceAll(';', ',')
        .replaceAll(RegExp(r'\s+'), '');

    context.read<PumpSettingsCubit>().sendSetting(finalPayload);
  }

  Future<String?> _showTextDialog(BuildContext context, String title, current) async {
    final controller = TextEditingController(text: current);
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return GlassyAlertDialog.show<String>(
      context: context,
      title: title,
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        onSubmitted: (_) => Navigator.pop(context, controller.text.trim()),
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