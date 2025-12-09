import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart' as di;

import '../bloc/setserial_bloc.dart';
import '../bloc/setserial_bloc_event.dart';
import '../bloc/setserial_state.dart';

class SerialSetCalibrationPage extends StatelessWidget {
  final int userId;
  final int controllerId;

  const SerialSetCalibrationPage({
    super.key,
    required this.userId,
    required this.controllerId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SetSerialBloc>()
        ..add(LoadSerialEvent(userId: userId, controllerId: controllerId)),
      child: Scaffold(
        backgroundColor: Colors.blue.shade400,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade400,
          title: const Text("SerialSet Calibration"),
        ),

        body: BlocConsumer<SetSerialBloc, SetSerialState>(
          listener: (context, state) {
            if (state is SendSerialSuccess ||
                state is ResetSerialSuccess ||
                state is ViewSerialSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.toString())),
              );
            }

            if (state is SendSerialError ||
                state is ResetSerialError ||
                state is ViewSerialError ||
                state is LoadSerialError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.toString())),
              );
            }
          },

          builder: (context, state) {
            /// ---------- LOADING ----------
            if (state is SetSerialLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            /// ---------- LIST DATA ----------
            if (state is SerialDataLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.nodeList.length,
                      itemBuilder: (context, index) {
                        final node = state.nodeList[index];

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// QR CODE
                              Expanded(
                                flex: 3,
                                child: Text(
                                  node["QRCode"] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),

                              /// SERIAL
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    node["serialNo"] ?? "",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),

                              /// VIEW ICON
                              IconButton(
                                icon: const Icon(Icons.visibility,
                                    color: Colors.white),
                                onPressed: () {
                                  context.read<SetSerialBloc>().add(
                                    ViewSerialEvent(
                                      userId: userId,
                                      controllerId: controllerId,
                                      sentSms: node["QRCode"],
                                    ),
                                  );
                                },
                              ),

                              /// SEND ICON
                              IconButton(
                                icon: const Icon(Icons.send,
                                    color: Colors.white),
                                onPressed: () {
                                  context.read<SetSerialBloc>().add(
                                    SendSerialEvent(
                                      userId: userId,
                                      controllerId: controllerId,
                                      sentSms: node["QRCode"],
                                      sendList: [
                                        {
                                          "QRCode": node["QRCode"],
                                          "serialNo": node["serialNo"],
                                          "nodeId": node["nodeId"],
                                        }
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// ---------- CANCEL BUTTON ----------
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              );
            }

            /// ---------- DEFAULT ----------
            return const Center(
              child: Text(
                "Loading...",
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
