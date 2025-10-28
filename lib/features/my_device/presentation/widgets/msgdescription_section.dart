

import 'package:flutter/material.dart';
import 'package:niagara_smart_drip_irrigation/common_widget/glass_effect.dart';

class MsgDescSection extends StatelessWidget {
  final String msg;
  const MsgDescSection({
    super.key,
    required this.msg,
  });

  @override
  Widget build(BuildContext context) {
    return  Center(child: Text(msg.isEmpty ? "No Message" : msg, textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white,)));
  }
}
