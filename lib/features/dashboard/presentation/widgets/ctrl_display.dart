import 'package:flutter/material.dart';

class CtrlDisplay extends StatelessWidget {
  final int signal;
  final int battery;
  final String status;
  final int vrb;
  final double amp;

  const CtrlDisplay({
    super.key,
    required this.signal,
    required this.battery,
    required this.status,
    required this.vrb,
    required this.amp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        // color: Color(0xFFC1F629),
        borderRadius: BorderRadius.circular(8),
        // border: Border.all()
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                const Icon(Icons.signal_cellular_alt,color: Color(0xFFC1F629)),
                Text("$signal%",style: TextStyle(color: Color(0xFFC1F629),fontWeight: FontWeight.bold),),
              ]),
               Column(children: [
              Text(status, style: const TextStyle(fontWeight: FontWeight.bold,color: Color(0xFFC1F629))),
              Text("VRB: $vrb  AMP: $amp",style: TextStyle(color: Color(0xFFC1F629),fontWeight: FontWeight.bold),),
              ]),
              Column(children: [
                const Icon(Icons.battery_full, color: Color(0xFFC1F629),),
                Text("$battery%",style: TextStyle(color: Color(0xFFC1F629),fontWeight: FontWeight.bold),),
              ]),
            ],
          ),

        ],
      ),
    );
  }
}
