import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/sendrev_model.dart';
import '../bloc/sendrev_bloc.dart';
import '../bloc/sendrev_bloc_event.dart';
import '../bloc/sendrev_bloc_state.dart';
import '../widgets/chat_bubble.dart';

class SendRevPage extends StatelessWidget {
  const SendRevPage(
      // {super.key, required userId, required subuserId, required controllerId, required fromDate, required toDate}
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send and Receive")),
      body: BlocBuilder<SendrevBloc, SendrevState>(
        builder: (context, state) {
          if (state is SendrevLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SendrevLoaded) {
            return ListView.builder(
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final m = state.messages[index];
                return ChatBubble(
                  msg: SendrevDatum(
                    date: m.date, msgType: m.msgType, ctrlMsg: m.ctrlMsg, ctrlDesc: m.ctrlMsg, status: m.status, msgCode: "", time: m.time,
                  ),
                );
              },
            );
          }

          if (state is SendrevError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
