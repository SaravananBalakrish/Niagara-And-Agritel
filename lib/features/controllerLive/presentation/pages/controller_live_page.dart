import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glass_effect.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glassy_wrapper.dart';
import 'package:niagara_smart_drip_irrigation/features/dashboard/domain/entities/controller_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/dashboard/presentation/widgets/fertstatus_section.dart';
import 'package:niagara_smart_drip_irrigation/features/dashboard/presentation/widgets/previousday_section.dart';
import 'package:niagara_smart_drip_irrigation/features/dashboard/presentation/widgets/prs_gauge_section.dart';
import 'package:niagara_smart_drip_irrigation/features/dashboard/presentation/widgets/well_level_section.dart';

import '../../../dashboard/presentation/widgets/ctrl_display.dart';
import '../../../dashboard/presentation/widgets/latestmsg_section.dart';
import '../../../dashboard/presentation/widgets/pressure_section.dart';
import '../../../dashboard/presentation/widgets/ryb_section.dart';
import '../../../dashboard/presentation/widgets/timer_section.dart';
import '../widgets/livepage_display_values.dart';

class CtrlLivePage extends StatelessWidget {
  final ControllerEntity? selectedController;

  const CtrlLivePage({super.key, this.selectedController});

  @override
  Widget build(BuildContext context) {

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return true;
      },
      child: GlassyWrapper(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Controller Live Page"),
          ),
          body: GlassCard(
            margin: EdgeInsets.all(10),
            child: selectedController == null
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      "Last sync: ${selectedController!.livesyncTime}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GlassCard(
                    child: CtrlDisplay(
                      signal: 50,
                      battery: 50,
                      status: selectedController!.status,
                      vrb: 456,
                      amp: 200,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        selectedController!.liveMessage.motorOnOff == "0"
                            ? 'assets/images/common/ui_motor.gif' // motor ON
                            : selectedController!.liveMessage.motorOnOff == "1"
                            ? 'assets/images/common/live_motor_off.png' // motor OFF
                            : 'assets/images/common/ui_motor_yellow.png', // no status
                        width: 60,
                        height: 60,
                      ),
                      LatestMsgSection(
                        msg: ([1, 5].contains(selectedController!.modelId))
                            ? selectedController!.msgDesc
                            : "${selectedController!.msgDesc} \n ${selectedController!.ctrlLatestMsg}",
                      ),
                      Image.asset(
                        selectedController!.liveMessage.valveOnOff == "0"
                            ? 'assets/images/common/valve_open.gif' // valve open
                            : selectedController!.liveMessage.valveOnOff == "1"
                            ? 'assets/images/common/valve_stop.png' // valve stop
                            : 'assets/images/common/valve_no_communication.png', // no communication
                        width: 60,
                        height: 60,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RYBSection(
                    r: selectedController!.liveMessage.rVoltage,
                    y: selectedController!.liveMessage.yVoltage,
                    b: selectedController!.liveMessage.bVoltage,
                    c1: selectedController!.liveMessage.rCurrent,
                    c2: selectedController!.liveMessage.yCurrent,
                    c3: selectedController!.liveMessage.bCurrent,
                  ),
                  const SizedBox(height: 8),
                  if ([1, 5].contains(selectedController!.modelId))
                    Column(
                      children: [
                        PressureSection(
                          prsIn: selectedController!.liveMessage.prsIn,
                          prsOut: selectedController!.liveMessage.prsOut,
                          activeZone: selectedController!.zoneNo,
                          fertlizer: '',
                        ),
                        const SizedBox(height: 8),
                        TimerSection(
                          setTime: selectedController!.setFlow,
                          remainingTime: selectedController!.remFlow,
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  TimerSection(
                    setTime: selectedController!.setFlow,
                    remainingTime: selectedController!.remFlow,
                  ),
                  const SizedBox(height: 8),
                  GlassCard(
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Your LiveDisplayObject is used here
                          LiveDisplayObject(
                            disMsg1: "Phase",
                            disValues1: "2-Phase",
                            disMsg2: "Bat.V",
                            disValues2: "4.4V",
                          ),
                          const SizedBox(height: 10),
                          LiveDisplayObject(
                            disMsg1: "Program",
                            disValues1: "Program 2",
                            disMsg2: "Mode",
                            disValues2: "Timer",
                          ),
                          const SizedBox(height: 10),
                          LiveDisplayObject(
                            disMsg1: "Zone",
                            disValues1: "001",
                            disMsg2: "Valve",
                            disValues2: "V,1,2,3",
                          ),
                          const SizedBox(height: 10),
                          PressureGaugeSection(prsIn: 2.5, prsOut: 3.5, fertFlow: 200),
                          const SizedBox(height: 10),
                          WellLevelSection(level: 34, flow: 343)
                        ],
                      ),
                    ),
                  ),
                  FertStatusSection(F1: "1", F2: "2", F3: "0", F4: "1", F5: "1", F6: "0"),
                  const SizedBox(height: 10),
                  GlassCard(
                    child: Center(
                      child: LiveDisplayObject(
                        disMsg1: "Ec",
                        disValues1: "21.3",
                        disMsg2: "PH",
                        disValues2: "7.0",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GlassCard(
                    child: Center(
                      child: Column(
                        children: [
                          LiveDisplayObject(
                            disMsg1: "F1",
                            disValues1: "00:00",
                            disMsg2: "F2",
                            disValues2: "00:00",
                          ),
                          LiveDisplayObject(
                            disMsg1: "F3",
                            disValues1: "00:00",
                            disMsg2: "F4",
                            disValues2: "00:00",
                          ),
                          LiveDisplayObject(
                            disMsg1: "F5",
                            disValues1: "00:00",
                            disMsg2: "F6",
                            disValues2: "00:00",
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  PreviousDaySection(
                    runTimeToday: "00:23:00",
                    runTimePrevious: "00:23:00",
                    flowToday: "1234",
                    flowPrevious: "4234",
                    cFlowToday: "23",
                    cFlowPrevious: "34",
                  ),
                  const SizedBox(height: 10),
                  GlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "Version:",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "V3.22.23.2",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}