import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/action_button.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/alert_dialog.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glass_effect.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glassy_wrapper.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/retry.dart';
import 'package:niagara_smart_drip_irrigation/core/services/time_picker_service.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/domain/entities/menu_item_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/domain/entities/template_json_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/cubit/pump_settings_cubit.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/widgets/setting_list_tile.dart';

import '../../../../core/di/injection.dart' as di;
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
          actions: const [
            IconButton(onPressed: null, icon: Icon(Icons.hide_source, color: Colors.white)),
          ],
        ),
        body: GlassyWrapper(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (n) {
              n.disallowIndicator();
              return true;
            },
            child: _buildBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<PumpSettingsCubit, PumpSettingsState>(
      builder: (context, state) {
        if (state is GetPumpSettingsInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is GetPumpSettingsLoaded) {
          return _buildSettingMenuList(context, state.settings);
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
    );
  }

  Widget _buildSettingMenuList(BuildContext context, MenuItemEntity menuItem) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemCount: menuItem.template.sections.length,
      itemBuilder: (context, index) {
        final section = menuItem.template.sections[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(section.sectionName, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildSettingsList(context, section.settings, index),
          ],
        );
      },
    );
  }

  Widget _buildSettingsList(BuildContext context, List<SettingsEntity> settings, int sectionIndex) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: settings.length,
      itemBuilder: (context, index) {
        final item = settings[index];
        return Row(
          spacing: 8,
          children: [
            if([4,5].contains(item.widgetType))
              Expanded(
                child: GlassCard(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for(int i = 0 ; i < item.title.split(';').length; i++)
                        SettingListTile(
                          title: item.title.split(';')[i].trim(),
                          trailing: Text(item.value.split(';')[i].trim(), style: Theme.of(context).textTheme.bodyMedium,),
                          onTap: () async {
                            final cubit = context.read<PumpSettingsCubit>();
                            final times = item.value.split(';');

                            final newTime = await TimePickerService.show(
                                title: item.title.split(';')[i].trim(),
                                context: context,
                                initialTime: times[i].trim()
                            );
                            if (newTime == null) return;
                            final List<String> newValues = List<String>.from(times);
                            newValues[i] = newTime.trim();

                            final newValue = newValues.join(';');
                            if (newValue != item.value) {
                              cubit.updateSettingValue(newValue, sectionIndex, index);
                            }
                          },
                        )
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: GlassCard(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.zero,
                  child: SettingListTile(
                    title: item.title,
                    trailing: _buildTrailing(item, context, sectionIndex, index),
                    onTap: () => _handleTap(context, item, sectionIndex, index),
                  ),
                ),
              ),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {
                  final cubit = context.read<PumpSettingsCubit>();
                  String cleanedValue = settings[index].value.trim();

                  String payload;
                  if ([4, 5].contains(item.widgetType)) {
                    payload = "${settings[index].smsFormat},$cleanedValue";
                  } else {
                    payload = "${settings[index].smsFormat}$cleanedValue";
                  }

                  String finalPayload = payload.replaceAll(':', '').replaceAll(';', ',').replaceAll(RegExp(r'\s+'), '').trim();
                  cubit.sendSetting(finalPayload);
                },
                icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrailing(SettingsEntity item, BuildContext context, int sectionIndex, int settingIndex) {
    final cubit = context.read<PumpSettingsCubit>();

    switch (item.widgetType) {
      case 1:
        return Text(item.value.isEmpty ? "-" : item.value, style: Theme.of(context).textTheme.bodyMedium);
      case 2:
        final isOn = item.value == "ON";
        return Switch(
            value: isOn,
            onChanged: (newValue) {
              final newVal = item.value == "OF" ? "ON" : "OF";
              cubit.updateSettingValue(newVal, sectionIndex, settingIndex);
            }
        );
      case 3:
        return Text(item.value.isEmpty ? "00:00:00" : item.value, style: Theme.of(context).textTheme.bodyMedium);
      default:
        return Text(item.value);
    }
  }

  void _handleTap(BuildContext context, SettingsEntity item, int sectionIndex, int settingIndex) async {
    final cubit = context.read<PumpSettingsCubit>();

    switch (item.widgetType) {
      case 1:
        final newVal = await _showTextDialog(context, item.title, item.value);
        if (newVal != null && newVal != item.value) {
          cubit.updateSettingValue(newVal, sectionIndex, settingIndex);
        }
        break;

      case 2:
        final newVal = item.value == "OF" ? "ON" : "OF";
        cubit.updateSettingValue(newVal, sectionIndex, settingIndex);
        break;

      case 3:
        final newTime = await TimePickerService.show(
          title: item.title,
          context: context,
          initialTime: item.value,
        );
        if (newTime != null && newTime != item.value) {
          cubit.updateSettingValue(newTime, sectionIndex, settingIndex);
        }
        break;
    }
  }

  Future<String?> _showTextDialog(BuildContext context, String title, String current) async {
    final controller = TextEditingController(text: current);

    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );

    return await GlassyAlertDialog.show<String>(
      context: context,
      title: title,
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => Navigator.pop(context, controller.text.trim()),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      actions: [
        ActionButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ActionButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          isPrimary: true,
          child: const Text("Save"),
        ),
      ],
    );
  }
}