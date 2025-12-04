import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glass_effect.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/domain/entities/menu_item_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/bloc/pump_settings_bloc.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/bloc/pump_settings_event.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/widgets/setting_list_tile.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/widgets/setting_switch.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/widgets/setting_text_form_field.dart';

import '../../../../core/di/injection.dart' as di;
import '../../../../core/services/time_picker_service.dart';
import '../../../../core/widgets/glassy_wrapper.dart';
import '../../../../core/widgets/retry.dart';
import '../../domain/entities/template_json_entity.dart';
import '../bloc/pump_settings_state.dart';
import '../widgets/setting_time_picker.dart';

class PumpSettingsPage extends StatelessWidget {
  final int userId, subUserId, controllerId, menuId;
  final String? menuName;
  const PumpSettingsPage({super.key, required this.userId, required this.subUserId, required this.controllerId, required this.menuId, required this.menuName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PumpSettingsBloc>()
        ..add(GetPumpSettingsEvent(userId: userId, subUserId: subUserId, controllerId: controllerId, menuId: menuId)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(menuName ?? 'Pump Settings'),
          actions: [
            IconButton(
                onPressed: null,
                icon: Icon(Icons.hide_source, color: Colors.white,)
            )
          ],
        ),
        body: GlassyWrapper(
            child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  notification.disallowIndicator();
                  return true;
                },
                child: _buildBody(context)
            )
        ),
      ),
    );
  }

  Widget _buildBody (BuildContext context) {
    return BlocBuilder<PumpSettingsBloc, PumpSettingsState>(
        builder: (context, state) {
          if(state is GetPumpSettingsInitial) {
            return Center(
                child: CircularProgressIndicator()
            );
          }
          else if(state is GetPumpSettingsLoaded) {
            return _buildSettingMenuList(context, state.settings);
          } else if(state is GetPumpSettingsError) {
            return Center(
              child: Retry(
                message: state.message,
                onPressed: () => context.read<PumpSettingsBloc>().add(
                    GetPumpSettingsEvent(userId: userId, subUserId: subUserId, controllerId: controllerId, menuId: menuId)
                ),
              ),
            );
          }
          return SizedBox();
        }
    );
  }

  Widget _buildSettingMenuList(BuildContext context, MenuItemEntity menuItem) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemCount: menuItem.templateJsonEntity.sections.length,
      itemBuilder: (context, index) {
        final group = menuItem.templateJsonEntity.sections[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              group.sectionName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildSettingMenu(context, group.settings),
          ],
        );
      },
    );
  }

  Widget _buildSettingMenu(BuildContext context, List<SettingsEntity> settingList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: settingList.length,
      itemBuilder: (context, index) {
        final item = settingList[index];
        return Row(
          spacing: 8,
          children: [
            Expanded(
              child: GlassCard(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                padding: EdgeInsets.zero,
                child: SettingListTile(
                    title: item.title,
                    trailing: _getTrailingWidget(item.widgetType),
                  onTap: () {
                    _onTapFunction(item.widgetType, context, "12:00:00");
                  },
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.send, color: Theme.of(context).primaryColor,)
              ),
            )
          ],
        );
      },
    );
  }

  Widget _getTrailingWidget(int type) {
    Widget customWidget = Text("Unknow Widget");
    switch(type) {
      case 1:
        return SettingTextFormField();
      case 2:
        return SettingSwitch(value: false, onChanged: (newValue){});
      case 3:
        return Text("00:00:00");
      case 4 : case 5:
        return Row(
          children: [
            Text("00:00:00"),
            Text("00:00:00"),
            // SettingTimePicker(initialTime: '00:12:00', onTimeChanged: (String value) {  },),
            // SettingTimePicker(initialTime: '00:24:00', onTimeChanged: (String value) {  },),
          ],
        );
      }
    return customWidget;
  }

  void _onTapFunction(int type, BuildContext context, String initialTime) {
    switch(type) {
      case 3:
        _showTimePicker(context, initialTime);
    }
  }

  void _showTimePicker(BuildContext context, String initialTime) async {
    final selectedTime = await TimePickerService.show(
      context: context,
      initialTime: initialTime,
    );

    if (selectedTime != null && selectedTime != initialTime) {
      print("selectedTime :: $selectedTime");
    }
  }
}
