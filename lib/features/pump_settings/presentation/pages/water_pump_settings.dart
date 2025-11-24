import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glass_effect.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glassy_wrapper.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/domain/entities/settings_menu_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/bloc/pump_settings_event.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/bloc/pump_settings_state.dart';

import '../../../../core/di/injection.dart' as di;
import '../../../../core/widgets/retry.dart';
import '../../domain/usecsases/get_settings_menu_usecase.dart';
import '../bloc/pump_settings_bloc.dart';

class PumpSettingsMenu extends StatelessWidget {
  final int userId, subUserId, controllerId;
  const PumpSettingsMenu({super.key, required this.userId, required this.subUserId, required this.controllerId});

  @override
  Widget build(BuildContext context) {
    final getSettingsMenuUsecase = di.sl<GetPumpSettingsMenuUsecase>();
    return BlocProvider(
        create: (context) => PumpSettingsBloc(
            getSettingsMenuUsecase: getSettingsMenuUsecase
        )..add(GetPumpSettingsMenuEvent(userId: userId, subUserId: subUserId, controllerId: controllerId)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text("Pump Settings"),),
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
          if(state is GetPumpSettingsMenuInitial) {
            return Center(
              child: CircularProgressIndicator()
            );
          }
          else if(state is GetPumpSettingsMenuLoaded) {
            return _buildSettingMenuList(context, state.settingMenuList);
          } else if(state is GetPumpSettingsMenuError) {
            return Center(
              child: Retry(
                message: state.message,
                onPressed: () => context.read<PumpSettingsBloc>().add(
                    GetPumpSettingsMenuEvent(userId: userId, subUserId: subUserId, controllerId: controllerId)
                ),
              ),
            );
          }
          return SizedBox();
        }
    );
  }

  Widget _buildSettingMenuList(BuildContext context, List<SettingsMenuEntity> settingMenuList) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: settingMenuList.length,
      itemBuilder: (BuildContext context, int index) {
        final item = settingMenuList[index];
        return GlassCard(
          child: InkWell(
            onTap: () {
              print(item.menuItem);
            },
            borderRadius: BorderRadius.circular(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Icon(
                  Icons.settings,
                  size: 25.0,
                ),
                Text(
                  item.menuItem,
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
    );
  }
}
