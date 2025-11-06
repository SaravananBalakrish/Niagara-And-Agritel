import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niagara_smart_drip_irrigation/core/utils/route_constants.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glass_effect.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/domain/usecases/group_fetching_usecase.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/presentation/bloc/group_bloc.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/presentation/bloc/group_event.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/presentation/bloc/auth_state.dart';

import '../../../../core/di/injection.dart' as di;
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/group_state.dart';

class Groups extends StatelessWidget {
  const Groups({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final groupFetchingUseCase = di.sl<GroupFetchingUsecase>();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedOut) {
          context.go(RouteConstants.login);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (authState is Authenticated) {
            return BlocProvider(
              create: (BuildContext context) => GroupBloc(groupFetchingUsecase: groupFetchingUseCase)
                ..add(FetchGroupsEvent(authState.user.userDetails.id)),
              child: BlocBuilder<GroupBloc, GroupState>(
                builder: (context, state) {
                  if (state is GroupLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GroupLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        final authState = context.read<AuthBloc>().state;
                        if (authState is Authenticated) {
                          context.read<GroupBloc>().add(FetchGroupsEvent(authState.user.userDetails.id));
                        }
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.groups.length,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        itemBuilder: (context, index) {
                          final group = state.groups[index];
                          final itemCount = state.groups.length;
                          BorderRadius borderRadius;
                          if (index == 0) {
                            borderRadius = const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            );
                          } else if (index == itemCount - 1) {
                            borderRadius = const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            );
                          } else {
                            borderRadius = BorderRadius.zero;
                          }
                          return GlassCard(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            borderRadius: borderRadius,
                            child: ListTile(
                              title: Text(group.groupName),
                              subtitle: Text('Devices: ${group.groupName}'),
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColorLight,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(color: Theme.of(context).primaryColor),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: borderRadius,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is GroupFetchingError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${state.message}'),
                          ElevatedButton(
                            onPressed: () {
                              final bloc = context.read<GroupBloc>();
                              final authState = context.read<AuthBloc>().state;
                              if (authState is Authenticated) {
                                bloc.add(FetchGroupsEvent(authState.user.userDetails.id));
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            );
          } else if (authState is AuthError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}