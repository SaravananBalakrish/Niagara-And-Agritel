import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niagara_smart_drip_irrigation/core/utils/route_constants.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glass_effect.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/entities/sub_user_entity.dart';

import '../../../../../core/di/injection.dart' as di;
import '../bloc/sub_users_bloc.dart';
import '../bloc/sub_users_event.dart';
import '../bloc/sub_users_state.dart';

class SubUsers extends StatelessWidget {
  final int userId;
  const SubUsers({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final bloc = di.sl<SubUsersBloc>();
        bloc.add(GetSubUsersEvent(userId: userId));
        return bloc;
      },
      child: BlocBuilder<SubUsersBloc, SubUsersState>(
        builder: (context, state) {
          if (state is SubUserLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SubUsersError) {
            return Center(child: Text(state.message));
          }
          if (state is SubUsersLoaded) {
            return RefreshIndicator(
              onRefresh: () async{
                final bloc = di.sl<SubUsersBloc>();
                bloc.add(GetSubUsersEvent(userId: userId));
              },
              child: ListView.builder(
                itemCount: state.subUsersList.length,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemBuilder: (context, index) {
                  final isFirst = index == 0;
                  final SubUserEntity subUserEntity = state.subUsersList[index];
                  final isLast = index == state.subUsersList.length - 1;
                  final borderRadius = BorderRadius.only(
                    topLeft: isFirst ? const Radius.circular(16) : Radius.zero,
                    topRight: isFirst ? const Radius.circular(16) : Radius.zero,
                    bottomLeft: isLast ? const Radius.circular(16) : Radius.zero,
                    bottomRight: isLast ? const Radius.circular(16) : Radius.zero,
                  );
                  return GlassCard(
                    padding: EdgeInsets.zero,
                    borderRadius: borderRadius,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      minTileHeight: 40,
                      leading: Text(subUserEntity.subUserCode),
                      title: Text(subUserEntity.userName, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(subUserEntity.mobileNumber),
                      onTap: () {
                        context.push(RouteConstants.subUserDetails, extra: {"userId": userId, "subUserCode": subUserEntity.subUserCode});
                      },
                    ),
                  );
                },
              ),
            );
          }
          return const Center(child: Text("Groups"));
        },
      ),
    );
  }
}