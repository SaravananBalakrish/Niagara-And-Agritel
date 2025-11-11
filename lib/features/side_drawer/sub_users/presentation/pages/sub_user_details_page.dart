import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:niagara_smart_drip_irrigation/core/widgets/custom_phone_field.dart';

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
    final _formKey = GlobalKey<FormState>();
    final _phoneKey = GlobalKey<CustomPhoneFieldState>();
    final _nameKey = GlobalKey<FormFieldState>();
    if (state is SubUserDetailsLoading || state is SubUserInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is SubUserDetailsError) {
      return Center(child: Text('Error loading sub-user : ${state.message}'));
    }

    if (state is SubUserDetailsLoaded) {
      final subUserDetail = state.subUserDetails.subUserDetail;
      return Form(
        key: _formKey,
        child: SingleChildScrollView(
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
              _buildPhoneField(context, subUserDetail.mobileNumber, _phoneKey),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Sub-user name',
                initialValue: subUserDetail.userName,
                nameKey: _nameKey,
                onChanged: (value) {}, // Update Bloc if needed, e.g., bloc.add(UpdateNameEvent(value));
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
              _buildActionButtons(context, _formKey, _phoneKey, _nameKey, state),
            ],
          ),
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

  Widget _buildPhoneField(BuildContext context, String initialPhone, GlobalKey<CustomPhoneFieldState> phoneKey) {
    return CustomPhoneField(
      key: phoneKey,
      initialCountryCode: 'IN',
      initialValue: initialPhone,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        labelText: 'Sub User Phone number',
        suffixIcon: Icon(Icons.verified, color: Colors.green),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required GlobalKey<FormFieldState> nameKey,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          key: nameKey,
          decoration: InputDecoration(
            label: Text(label)
          ),
          initialValue: initialValue,
          onChanged: onChanged,
          validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
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

  Widget _buildActionButtons(
      BuildContext context,
      GlobalKey<FormState> formKey,
      GlobalKey<CustomPhoneFieldState> phoneKey,
      GlobalKey<FormFieldState> nameKey,
      SubUsersState state, // Pass state for loaded data if needed
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => _handleSubmit(context, formKey, phoneKey, nameKey, state),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Submit'),
        ),
        ElevatedButton(
          onPressed: () => context.pop(),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          onPressed: () => _handleDelete(context, state),
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    );
  }

  void _handleSubmit(
      BuildContext context,
      GlobalKey<FormState> formKey,
      GlobalKey<CustomPhoneFieldState> phoneKey,
      GlobalKey<FormFieldState> nameKey,
      SubUsersState state,
      ) {
    if (formKey.currentState!.validate()) {
      final bloc = context.read<SubUsersBloc>();
      final fullPhone = phoneKey.currentState!.fullPhoneNumber;
      final updatedName = nameKey.currentState!.value; // Gets current text value
      // Collect other changes (e.g., selected controllers from Bloc state)
      if (state is SubUserDetailsLoaded) {
        // Example: Dispatch update event with collected data
        // bloc.add(UpdateSubUserEvent(
        //   phone: fullPhone,
        //   name: updatedName,
        //   // controllerSelections: ... from state or local tracking
        // ));
        print('Submitting: Phone=$fullPhone, Name=$updatedName');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sub-user updated!')),
        );
        // Optionally pop or refresh
      }
    }
  }

  void _handleDelete(BuildContext context, SubUsersState state) {
    final bloc = context.read<SubUsersBloc>();
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
              if (state is SubUserDetailsLoaded) {
                // bloc.add(DeleteSubUserEvent(subUserId: subUserDetailsParams.subUserId)); // Use params or state
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sub-user deleted!')),
                );
                context.pop(); // Navigate back after delete
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}