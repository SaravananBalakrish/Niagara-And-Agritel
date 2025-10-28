// lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niagara_smart_drip_irrigation/common_widget/glass_effect.dart';
import '../../../../core/utils/route_constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../dashboard/presentation/bloc/dashboard_event.dart';
import '../../../my_device/presentation/widgets/actions_section.dart';
import '../../../my_device/presentation/widgets/ctrl_display.dart';
import '../../../my_device/presentation/widgets/header_section.dart';
import '../../../my_device/presentation/widgets/latestmsg_section.dart';
import '../../../my_device/presentation/widgets/motor_valve_section.dart';
import '../../../my_device/presentation/widgets/pressure_section.dart';
import '../../../my_device/presentation/widgets/ryb_section.dart';
import '../../../my_device/presentation/widgets/sync_section.dart';
import '../../../my_device/presentation/widgets/timer_section.dart';
import '../bloc/dashboard_state.dart';
import 'package:get_it/get_it.dart' as di;

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = di.GetIt.instance.get<DashboardBloc>();
        final authState = context.read<AuthBloc>().state;
        if (authState is Authenticated) {
          if (bloc.state is! DashboardLoading && bloc.state is! DashboardGroupsLoaded) {
            bloc.add(FetchDashboardGroupsEvent(authState.user.userDetails.id));
          }
        }
        return bloc;
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            final dashboardBloc = context.read<DashboardBloc>();
            if (dashboardBloc.state is! DashboardLoading && dashboardBloc.state is! DashboardGroupsLoaded) {
              dashboardBloc.add(FetchDashboardGroupsEvent(state.user.userDetails.id));
            }
          } else if (state is LoggedOut) {
            context.go(RouteConstants.login);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is Authenticated) {
              return BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, dashboardState) {
                  if (dashboardState is DashboardGroupsLoaded) {
                    // Assume bloc handles initial selection; if not, dispatch here once
                    final bloc = context.read<DashboardBloc>();
                    if (dashboardState.selectedGroupId == null && dashboardState.groups.isNotEmpty) {
                      // Dispatch once to select first group
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!bloc.isClosed) {
                          bloc.add(SelectGroupEvent(dashboardState.groups[0].userGroupId));
                        }
                      });
                    }

                    final selectedGroup = dashboardState.groups.firstWhere(
                          (group) => group.userGroupId == dashboardState.selectedGroupId,
                      orElse: () => dashboardState.groups.isNotEmpty ? dashboardState.groups[0] : null!,
                    );

                    final controllers = dashboardState.groupControllers[dashboardState.selectedGroupId] ?? [];
                    int effectiveIndex = dashboardState.selectedControllerIndex ?? 0; // Default to 0

                    // Clamp index to valid range (0 to length-1)
                    if (effectiveIndex >= controllers.length || effectiveIndex < 0) {
                      effectiveIndex = controllers.isNotEmpty ? 0 : -1; // -1 signals no selection
                    }

                    final selectedController = effectiveIndex >= 0 ? controllers[effectiveIndex] : null;

                    print("selectedController :: $selectedController :  $controllers");
                    print("Controller :: $controllers");
                    print("selectedController?.modelId :: ${selectedController?.modelId}");

                    return Scaffold(
                       appBar: AppBar(
                        title: Container(
                          width: 140,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                           alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/common/niagara/niagara_logo_small.png",color: Colors.white,
                          ),
                        ),
                        bottom: PreferredSize(
                          preferredSize: Size(MediaQuery.of(context).size.width, 40),
                          child: Container(
                            color: Theme.of(context).appBarTheme.backgroundColor,
                            child: Row(
                              children: [
                                PopupMenuButton<int>(
                                  icon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        selectedGroup.groupName,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                                    ],
                                  ),
                                  onSelected: (groupId) {
                                    final bloc = context.read<DashboardBloc>();
                                    if (!bloc.isClosed) {
                                      final userId = selectedGroup.userId;
                                      if (!dashboardState.groupControllers.containsKey(groupId)) {
                                        bloc.add(FetchControllersEvent(userId, groupId));
                                      }
                                      bloc.add(SelectGroupEvent(groupId));
                                    }
                                  },
                                  itemBuilder: (context) => dashboardState.groups.map((group) => PopupMenuItem<int>(
                                    value: group.userGroupId,
                                    child: Text(group.groupName),
                                  )).toList(),
                                ),
                                Container(width: 1, height: 20, color: Colors.white54,),
                                if (controllers.isNotEmpty)
                                  if (controllers.isNotEmpty)
                                    PopupMenuButton<int>(
                                      enabled: controllers.isNotEmpty,
                                      icon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            selectedController?.deviceName ?? 'Select controller',
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                          const Icon(Icons.arrow_drop_down, color: Colors.white),
                                        ],
                                      ),
                                      onSelected: (controllerIndex) {
                                        final bloc = context.read<DashboardBloc>();
                                        if (!bloc.isClosed) {
                                          bloc.add(SelectControllerEvent(controllerIndex));
                                        }
                                      },
                                      itemBuilder: (context) => controllers.isNotEmpty
                                          ? controllers.asMap().entries
                                          .map<PopupMenuEntry<int>>((entry) {
                                        final index = entry.key;
                                        final ctrl = entry.value;
                                        final isSelected = index == effectiveIndex; // Highlight current
                                        return PopupMenuItem<int>(
                                          value: index,
                                          child: Row(
                                            children: [
                                              Text(ctrl.deviceName),
                                              if (isSelected) const Icon(Icons.check, size: 16, color: Colors.green),
                                            ],
                                          ),
                                        );
                                      }).toList()
                                          : <PopupMenuEntry<int>>[
                                        const PopupMenuItem<int>(
                                          enabled: false,
                                          child: Text('No controllers available'),
                                        )
                                      ],
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final height = constraints.maxHeight;

                          int modelCheck = ([1, 5, ].contains(selectedController?.modelId)) ? 300 : 120;
                          print("modelCheck:$modelCheck");
                           double scale(double size) => size * (width / modelCheck);

                          return Container(
                            width: width,
                            height: height,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).colorScheme.primaryContainer,
                                  Colors.black87,
                                ],
                              ),
                            ),
                            child: selectedController == null
                                ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  SizedBox(height: scale(16)),
                                  Text(
                                    "Select a controller...",
                                    style: TextStyle(
                                      fontSize: scale(14),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(scale(2)),
                                child: GlassCard(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      HeaderSection(
                                        ctrlName: selectedController.deviceName,
                                        isMqttConnected:
                                        selectedController.ctrlStatusFlag == '1',
                                      ),
                                      SizedBox(height: scale(8)),
                                      SyncSection(
                                        liveSync: selectedController.livesyncTime,
                                        smsSync: selectedController.msgDesc,
                                        model: selectedController.modelId,
                                      ),
                                      SizedBox(height: scale(8)),
                                      GlassCard(
                                        child: CtrlDisplay(
                                          signal: 50,
                                          battery: 50,
                                          status: selectedController.status,
                                          vrb: 456,
                                          amp: 200,
                                        ),
                                      ),
                                      SizedBox(height: scale(8)),
                                      RYBSection(
                                        r: selectedController.liveMessage.rVoltage,
                                        y: selectedController.liveMessage.yVoltage,
                                        b: selectedController.liveMessage.bVoltage,
                                        c1: selectedController.liveMessage.rCurrent,
                                        c2: selectedController.liveMessage.yCurrent,
                                        c3: selectedController.liveMessage.bCurrent,
                                      ),
                                      SizedBox(height: scale(8)),
                                      MotorValveSection(
                                        motorOn: selectedController.liveMessage.motorOnOff,
                                        motorOn2: selectedController.liveMessage.valveOnOff,
                                        valveOn: selectedController.liveMessage.valveOnOff,
                                        model: selectedController.modelId,
                                      ),
                                      SizedBox(height: scale(8)),
                                      if ([1, 5].contains(selectedController.modelId))
                                        Column(
                                          children: [
                                            PressureSection(
                                              prsIn: selectedController.liveMessage.prsIn,
                                              prsOut: selectedController.liveMessage.prsOut,
                                              activeZone: selectedController.zoneNo,
                                              fertlizer: '',
                                            ),
                                            SizedBox(height: scale(8)),
                                            TimerSection(
                                              setTime: selectedController.setFlow,
                                              remainingTime: selectedController.remFlow,
                                            ),

                                          ],
                                        ),
                                      LatestMsgSection(
                                        msg: ([1, 5].contains(selectedController.modelId))
                                            ? selectedController.msgDesc
                                            : "${selectedController.msgDesc}\n${selectedController.ctrlLatestMsg}",
                                      ),
                                      SizedBox(height: scale(8)),
                                      ActionsSection(model: selectedController.modelId),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                    );
                  } else if (dashboardState is DashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (dashboardState is DashboardError) {
                    return Center(child: Text('Error: ${dashboardState.message}'));
                  }
                  return const SizedBox.shrink(); // Fallback
                },
              );
            } else if (authState is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (authState is AuthError) {
              return Center(
                child: Column(
                  children: [
                    Text('Error: ${authState.message}'),
                    ElevatedButton(
                      onPressed: () => context.read<AuthBloc>().add(CheckCachedUserEvent()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Please log in'));
            }
          },
        ),
      ),
    );
  }
}

