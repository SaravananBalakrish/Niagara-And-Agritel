import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/glass_effect.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/domain/usecases/group_fetching_usecase.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/presentation/bloc/group_bloc.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/presentation/bloc/group_event.dart';

import '../../../../core/di/injection.dart' as di;
import '../../../../core/widgets/retry.dart';
import '../bloc/group_state.dart';

class GroupsPage extends StatelessWidget {
  final int userId;
  const GroupsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final groupFetchingUseCase = di.sl<GroupFetchingUsecase>();
    final addGroupUseCase = di.sl<GroupAddingUsecase>();
    return BlocProvider(
      create: (BuildContext context) => GroupBloc(
        groupFetchingUsecase: groupFetchingUseCase,
        groupAddingUsecase: addGroupUseCase,
      )..add(FetchGroupsEvent(userId)),
      child: _GroupsContent(userId: userId,),
    );
  }
}

class _GroupsContent extends StatelessWidget {
  final int userId;
  const _GroupsContent({required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocListener<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupAddingLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is GroupAddingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<GroupBloc, GroupState>(
          builder: (context, state) {
            if (state is GroupLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GroupLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<GroupBloc>().add(FetchGroupsEvent(userId));
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.groups.length,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                      padding: EdgeInsets.zero,
                      borderRadius: borderRadius,
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 10, right: 5),
                        title: Text(group.groupName),
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
                        trailing: IntrinsicWidth(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                              IconButton(
                                onPressed: null,
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is GroupFetchingError) {
              return Retry(
                message: state.message,
                onPressed: () => context.read<GroupBloc>().add(FetchGroupsEvent(userId)),
              );
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGroupDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddGroupDialog(BuildContext context) {
    final bloc = context.read<GroupBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: AddGroupDialog(userId: userId),
      ),
    );
  }
}

class AddGroupDialog extends StatefulWidget {
  final int userId;
  const AddGroupDialog({super.key, required this.userId});

  @override
  State<AddGroupDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Group'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Enter group name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final groupName = controller.text.trim();
            if (groupName.isNotEmpty) {
              context.read<GroupBloc>().add(
                GroupAddEvent(
                  userId: widget.userId,
                  groupName: groupName,
                ),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// Legacy Groups widget (deprecated; use GroupsPage instead) - Removed provideBloc flag
@deprecated
class Groups extends StatelessWidget {
  final int userId;
  const Groups({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // Redirect to new implementation or throw if used
    throw UnimplementedError('Use GroupsPage instead for Clean Architecture compliance');
  }
}