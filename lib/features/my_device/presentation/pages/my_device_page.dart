import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/my_device_bloc.dart';
import '../bloc/my_device_event.dart';
import '../bloc/my_device_state.dart';
import '../widgets/header_section.dart';
import '../widgets/sync_section.dart';
import '../widgets/ctrl_display.dart';
import '../widgets/ryb_section.dart';
import '../widgets/motor_valve_section.dart';
import '../widgets/pressure_section.dart';
import '../widgets/timer_section.dart';
import '../widgets/actions_section.dart';

class MyDevicePage extends StatelessWidget {
  const MyDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyDeviceBloc()..add(LoadControllers()),
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/common/niagara/niagara_logo_small.png",
                height: 50,
              ),
            ),
            bottom: const TabBar(
              indicatorColor: Colors.white,
              isScrollable: true,
              labelColor: Colors.white,
              tabs: [
                Tab(text: "AGRI FARM"),
                Tab(text: "AGRTC"),
                Tab(text: "LIGHT"),
                Tab(text: "MQTT"),
                Tab(text: "PUMP"),
              ],
            ),
          ),
          body: BlocBuilder<MyDeviceBloc, MyDeviceState>(
            builder: (context, state) {
              if (state is MyDeviceLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MyDeviceLoaded) {
                return Expanded(
                  child: TabBarView(
                    children: List.generate(5, (tabIndex) {
                      // Filter controllers for this tab if needed
                      final controllersForTab = state.controllers
                          .where((c) => c.tabIndex == tabIndex) // optional filter
                          .toList();

                      if (controllersForTab.isEmpty) {
                        return const Center(child: Text("No devices"));
                      }

                      return PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controllersForTab.length,
                        itemBuilder: (context, index) {
                          final ctrl = controllersForTab[index];
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                HeaderSection(
                                    ctrlName: ctrl.name,
                                    isMqttConnected: ctrl.mqttConnected),
                                const SizedBox(height: 8),
                                SyncSection(
                                    liveSync: ctrl.liveSync, smsSync: ctrl.smsSync),
                                const SizedBox(height: 8),
                                CtrlDisplay(
                                    signal: ctrl.signal,
                                    battery: ctrl.battery,
                                    status: ctrl.status,
                                    vrb: ctrl.vrb,
                                    amp: ctrl.amp),
                                const SizedBox(height: 8),
                                RYBSection(
                                    r: ctrl.r,
                                    y: ctrl.y,
                                    b: ctrl.b,
                                    c1: ctrl.c1,
                                    c2: ctrl.c2,
                                    c3: ctrl.c3),
                                const SizedBox(height: 8),
                                MotorValveSection(
                                    motorOn: ctrl.motorOn, valveOn: ctrl.valveOn),
                                const SizedBox(height: 8),
                                PressureSection(
                                    prsIn: ctrl.prsIn,
                                    prsOut: ctrl.prsOut,
                                    activeZone: ctrl.activeZone),
                                const SizedBox(height: 8),
                                TimerSection(
                                    setTime: ctrl.setTime,
                                    remainingTime: ctrl.remainingTime),
                                const SizedBox(height: 8),
                                const ActionsSection(),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                );
              } else if (state is MyDeviceError) {
                return Center(child: Text("Error: ${state.message}"));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}


