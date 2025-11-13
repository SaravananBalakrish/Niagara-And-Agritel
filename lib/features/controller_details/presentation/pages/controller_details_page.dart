import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glass_effect.dart';
import 'package:niagara_smart_drip_irrigation/features/controller_details/domain/entities/controller_details_entities.dart';
import 'package:niagara_smart_drip_irrigation/features/controller_details/presentation/widgets/ctrlDetails_actionbtn.dart';
import 'package:niagara_smart_drip_irrigation/features/controller_details/presentation/widgets/ctrlDetails_infoRow.dart';
import '../widgets/commondropdown.dart';
import '../widgets/ctrlDetails_switchRow.dart';
import '../widgets/ctrlDetails_toggleRow.dart';
import '../widgets/ctrldetails_header_section.dart';



class ControllerDetailsPage extends StatefulWidget {
  const ControllerDetailsPage({super.key});

  @override
  State<ControllerDetailsPage> createState() => _ControllerDetailsPageState();
}

class _ControllerDetailsPageState extends State<ControllerDetailsPage> {
  late ControllerDetailsEntities controller;
  final TextEditingController simController = TextEditingController();
  String selectedCountryCode = "+91";

  final List<String> countryCodes = ["+91", "+1", "+44", "+61", "+971", "+81"];

  // Dummy group list (from JSON)
  final List<String> groupList = [
    "ARGTC",
    "1 WELL MOTOR 1",
    "1 WELL MOTOR 2",
    "A PON 8 Valve",
    "A PON 2 Valve",
    "BORE MOTORS",
    "PON 2 Bore Thotti",
    "PON 8 Bore Thotti",
  ];

  @override
  void initState() {
    super.initState();
    controller = ControllerDetailsEntities(
      wpsIp: "",
      wpsPort: "",
      wapIp: "",
      wapPort: "",
      msgDesc: "",
      motorStatus: "NA",
      programNo: "NA",
      zoneNo: "No Active Zone",
      zoneRunTime: "NA",
      zoneRemainingTime: "NA",
      menuId: "59",
      referenceId: "2",
      setFlow: "NA",
      remFlow: "NA",
      flowRate: "NA",
      programName: "No Active Program",
      simNumber: "7418040896",
      deviceName: "DURAISAMY",
      manualStatus: "0",
      dndStatus: "1",
      mobileCountryCode: "91",
      dealerId: 115,
      dealerName: "Niagara Solutions",
      productId: 11158,
      oldProductId: 0,
      userId: 4056,
      userDeviceId: 6946,
      dealerNumber: "7373705105",
      dealerCountryCode: "91",
      deviceId: "867624060017414",
      productDesc: "Smart Drip 4G",
      dateOfManufacture: "27/05/2022",
      warrentyMonths: 15,
      modelName: "Smart Drip 4G",
      modelId: 5,
      categoryName: "Controllers",
      operationMode: "10",
      gprsMode: "4",
      appSmsMode: "7",
      groupName: "ARGTC",
      groupId: 4609,
      serviceDealerId: 115,
      serviceDealerName: "Niagara Solutions",
      serviceDealerCountryCode: "91",
      serviceDealerMobileNumber: "7373705105",
      emailAddress: ",,,,",
      cctvStatusFlag: 0,
      mobCctv: "com.appburst.cctvcamerapros",
      webCctv: "http://www.cctvcamerapros.com/",
      customerName: "Raju",
      customerNumber: "9363060896",
      customerCountryCode: "91",
      customerUserId: 4056,
    );
    simController.text = controller.simNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A4D68),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4D68),
        title: const Text("CONTROLLER", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: GlassCard(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ControllerSectionHeader(title: "Controller Details"),
                GlassCard(
                  child: ControllerInfoRow(
                    label: "QR Code / Device ID:",
                    value: controller.deviceId,
                  ),
                ),
                 // Dropdown for Group Name
                GlassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Group Name",
                        style: TextStyle(color: Colors.white70),
                      ),
                      DropdownButton<String>(
                        dropdownColor: const Color(0xFF0A4D68),
                        value: controller.groupName,
                        items: groupList.map((name) {
                          return DropdownMenuItem(
                            value: name,
                            child: Text(
                              name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          // setState(
                          //       () => controller.groupName =
                          //       value ?? controller.groupName,
                          // );
                        },
                      ),
                    ],
                  ),
                ),
                 GlassCard(
                  child: ControllerInfoRow(
                    label: "Device Name",
                    value: controller.deviceName,
                  ),
                ),
                GlassCard(
                  child: ControllerInfoRow(
                    label: "Product",
                    value: controller.productDesc,
                  ),
                ),
                GlassCard(child: ControllerInfoRow(label: "Model", value: controller.modelName)),
                GlassCard(
                  child: ControllerInfoRow(
                    label: "Operation Mode",
                    value: controller.operationMode,
                  ),
                ),
                GlassCard(
                  child: ControllerInfoRow(
                    label: "Program Name",
                    value: controller.programName,
                  ),
                ),
                 GlassCard(
                  child: ControllerSwitchRow(
                    title: "INTERNET 4G",
                    value: controller.gprsMode == "4",onChanged: (val) {
                    print("INTERNET 2G/3G & WiFi: $val");
                  },
                  ),
                ),
                GlassCard(
                  child: ControllerSwitchRow(
                    title: "INTERNET 2G/3G & WiFi",
                    value: controller.gprsMode != "4", onChanged: (val) {
                    print("INTERNET 2G/3G & WiFi: $val");
                  },
                  ),
                ),
            GlassCard(
                    child: Row(
                      children: [
                        CommonDropdown(
                          value: selectedCountryCode,
                          items: countryCodes,
                          onChanged: (value) {
                            setState(() => selectedCountryCode = value ?? "+91");
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: simController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "SIM Number",
                              labelStyle: const TextStyle(color: Colors.white70),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white38,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.lightBlueAccent,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            GlassCard(
                  child: ControllerInfoRow(
                    label: "Date of Manufacturing",
                    value: controller.dateOfManufacture,
                  ),
                ),
                GlassCard(
                  child: ControllerInfoRow(
                    label: "Dealer Name",
                    value: controller.dealerName,
                  ),
                ),
            GlassCard(
                  child: ControllerInfoRow(
                    label: "Dealer Number",
                    value: controller.dealerNumber,
                  ),
                ),
                GlassCard(
                  child: ControllerInfoRow(
                    label: "Customer Name",
                    value: controller.customerName,
                  ),
                ),
                GlassCard(
                  child: ControllerInfoRow(
                    label: "Customer Number",
                    value: controller.customerNumber,
                  ),
                ),

                GlassCard(
                  child: ControllerSwitchRow(
                    title: "DUAL PUMP",
                    value: controller.dndStatus == "1",
                    onChanged: (val) {
                      print("DUAL PUMP switched: $val");
                    },
                  ),
                ),
                const SizedBox(height: 20),

              ControllerActionButtons(
                    buttons: [
                      ControllerButtonData(
                        title: "Submit",
                        color: Colors.grey,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Submitted: SIM ${simController.text}, Group ${controller.groupName}",),
                            ),
                          );
                        },
                      ),
                      ControllerButtonData(
                        title: "Replace",
                        color: Colors.blue,
                        onPressed: () {},
                      ),
                    ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}