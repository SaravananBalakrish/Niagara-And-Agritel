import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/bloc/pump_settings_bloc.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/pages/pump_settings_page.dart';

import '../../../core/di/injection.dart' as di;
import '../presentation/bloc/pump_settings_event.dart';
import '../presentation/bloc/pump_settings_menu_bloc.dart';
import '../presentation/pages/pump_settings_menu_page.dart';

abstract class PumpSettingsPageRoutes {
  static const String pumpSettingMenuList = '/settingMenuList';
  static const String pumpSettingsPage = '/pumpSettingsPage';
}

final pumpSettingsRoutes = <GoRoute>[
  GoRoute(
    path: PumpSettingsPageRoutes.pumpSettingMenuList,
    name: 'settingMenuList',
    builder: (context, state) {
      final params = state.extra as Map<String, dynamic>;

      return BlocProvider(
        create: (_) => di.sl<PumpSettingsMenuBloc>()
          ..add(GetPumpSettingsMenuEvent(
            userId: params['userId'] as int,
            subUserId: params['subUserId'] as int,
            controllerId: params['controllerId'] as int,
          )),
        child: PumpSettingsMenuPage(
          userId: params['userId'] as int,
          subUserId: params['subUserId'] as int,
          controllerId: params['controllerId'] as int,
        ),
      );
    },
  ),
  GoRoute(
    path: PumpSettingsPageRoutes.pumpSettingsPage,
    name: 'pumpSettingsPage',
    builder: (context, state) {
      final params = state.extra as Map<String, dynamic>;

      return BlocProvider(
        create: (_) => di.sl<PumpSettingsBloc>()
          ..add(GetPumpSettingsEvent(
            userId: params['userId'] as int,
            subUserId: params['subUserId'] as int,
            controllerId: params['controllerId'] as int,
            menuId: params['menuId'] as int,
          )),
        child: PumpSettingsPage(
          menuId: params['menuId'] as int,
          userId: params['userId'] as int,
          subUserId: params['subUserId'] as int,
          controllerId: params['controllerId'] as int,
          menuName: params['menuName'],
        ),
      );
    },
  ),
];