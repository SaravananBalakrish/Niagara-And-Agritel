import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart' as di;
import '../../domain/entities/sub_user_details_entity.dart';
import '../../domain/usecases/get_sub_user_details_usecase.dart';
import '../bloc/sub_users_bloc.dart';
import '../bloc/sub_users_event.dart';
import '../bloc/sub_users_state.dart';

class SubUserDetailsScreen extends StatelessWidget {
  final GetSubUserDetailsParams subUserDetailsParams;

  const SubUserDetailsScreen({
    super.key,
    required this.subUserDetailsParams,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SubUsersBloc>()
        ..add(LoadSubUserDetailsEvent(subUserDetailsParams: subUserDetailsParams)),
      child: BlocBuilder<SubUsersBloc, SubUsersState>(
        builder: (context, state) {
          return _buildBody(context, state);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, SubUsersState state) {
    if (state is SubUserDetailsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is SubUserDetailsError) {
      return Center(child: Text('Error loading sub-user : ${state.message}'));
    }

    if (state is SubUserDetailsLoaded) {
      final subUserDetail = state.subUserDetails.subUserDetail;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldRow(
              label: 'Sub-user Code',
              value: subUserDetail.subUserCode,
              isEditable: false,
            ),
            const SizedBox(height: 16),
            _buildPhoneField(context, subUserDetail.mobileNumber),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Sub-user name',
              initialValue: subUserDetail.userName,
              onChanged: (value) {},
            ),
            const SizedBox(height: 24),
            const Text(
              'List of controllers',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...state.subUserDetails.controllerList.map((controller) => _buildControllerTile(
              controller: controller,
              onSelectedChanged: (selected) {},
              onEnabledChanged: (enabled) {},
            )),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      );
    }
    return const Center(child: Text('Error loading sub-user'));
  }

  Widget _buildFieldRow({required String label, required String value, bool isEditable = true}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 16),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }

  Widget _buildPhoneField(BuildContext context, String initialPhone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sub-user Mobile Number', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text('+91'), Icon(Icons.arrow_drop_down, size: 20)],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.verified, color: Colors.green), // Validation checkmark
                ),
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildControllerTile({
    required SubUserControllerEntity controller,
    bool isSelected = false,
    bool isEnabled = false,
    required ValueChanged<bool> onSelectedChanged,
    required ValueChanged<bool> onEnabledChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (value) => onSelectedChanged(value ?? false),
            ),
            Expanded(child: Text(controller.deviceName)),
            const SizedBox(width: 16),
            Text('DND'),
            Switch(
              value: isEnabled,
              onChanged: onEnabledChanged,
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Submit'),
        ),
        ElevatedButton(
          onPressed: () => context.pop(),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    );
  }

 /* void _handleSubmit(BuildContext context) {
    final bloc = context.read<SubUserEditBloc>();
    bloc.add(UpdateSubUserEvent()); // Triggers usecase
  }

  void _handleDelete(BuildContext context) {
    final bloc = context.read<SubUserEditBloc>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this sub-user?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              bloc.add(DeleteSubUserEvent());
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }*/
}