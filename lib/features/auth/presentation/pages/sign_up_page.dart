import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niagara_smart_drip_irrigation/features/auth/domain/entities/user_entity.dart';

import '../../domain/usecases/login_usecase.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class UserProfileForm extends StatefulWidget {
  final bool isEdit;
  final UserEntity? initialData;

  const UserProfileForm({
    super.key,
    required this.isEdit,
    this.initialData,
  });

  @override
  State<UserProfileForm> createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  // Controllers for form fields
  late final TextEditingController _mobileController;
  late final TextEditingController _userNameController;
  late final TextEditingController _address1Controller;
  late final TextEditingController _address2Controller;
  late final TextEditingController _townController;
  late final TextEditingController _villageController;
  late final TextEditingController _cityController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _altPhoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  // Dropdown values
  String? _selectedOption;
  String? _selectedCountry;
  String? _selectedState;

  // Possible values for dropdowns (to validate prefills)
  final List<String> _optionValues = ['1', '2', '3'];
  final List<String> _countryValues = ['India', 'USA', 'UK'];
  final List<String> _stateValues = ['State 1', 'State 2', 'State 3'];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial data if editing
    _mobileController = TextEditingController(text: widget.initialData?.mobile ?? '');
    _userNameController = TextEditingController(text: widget.initialData?.name ?? '');
    _address1Controller = TextEditingController(text: widget.initialData?.addressOne ?? '');
    _address2Controller = TextEditingController(text: widget.initialData?.addressTwo ?? '');
    _townController = TextEditingController(text: widget.initialData?.town ?? '');
    _villageController = TextEditingController(text: widget.initialData?.village ?? '');
    _cityController = TextEditingController(text: widget.initialData?.city ?? '');
    _postalCodeController = TextEditingController(text: widget.initialData?.postalCode ?? '');
    _altPhoneController = TextEditingController(text: widget.initialData?.altPhoneNum != null && widget.initialData!.altPhoneNum.isNotEmpty ? widget.initialData!.altPhoneNum[0] : '');
    _emailController = TextEditingController(text: widget.initialData?.email ?? '');
    _passwordController = TextEditingController(text: widget.isEdit ? '' : '');

    // Prefill dropdowns and validate against possible values
    String? tempOption = widget.initialData?.userType.toString();
    _selectedOption = _optionValues.contains(tempOption) ? tempOption : null;

    _selectedCountry = widget.initialData?.country != null && _countryValues.contains(widget.initialData!.country) ? widget.initialData!.country : null;

    _selectedState = widget.initialData?.state != null && _stateValues.contains(widget.initialData!.state) ? widget.initialData!.state : null;
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _userNameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _townController.dispose();
    _villageController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _altPhoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Basic validation
  bool _validateForm() {
    if (_mobileController.text.isEmpty || _userNameController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill required fields')),
        );
      }
      return false;
    }
    if (!widget.isEdit && _passwordController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password is required for signup')),
        );
      }
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEdit ? 'Edit Profile' : 'Sign Up';

    return Scaffold(
      appBar: AppBar(
        title: Text(title,),
        leading: widget.isEdit
            ? IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        )
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _mobileController,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number *',
                        prefixIcon: Icon(Icons.phone, color: Theme.of(context).primaryColor),
                        prefixText: '+91 ',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _userNameController,
                      decoration: InputDecoration(
                        labelText: 'User Name *',
                        prefixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedOption,
                      decoration: InputDecoration(
                        labelText: 'Select One',
                        prefixIcon: Icon(Icons.list, color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: _optionValues.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedOption = value),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Address',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _address1Controller,
                      decoration: InputDecoration(
                        labelText: 'Address 1',
                        prefixIcon: Icon(Icons.location_on, color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _address2Controller,
                      decoration: InputDecoration(
                        labelText: 'Address 2',
                        prefixIcon: Icon(Icons.location_on, color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _townController,
                            decoration: InputDecoration(
                              labelText: 'Town',
                              prefixIcon: Icon(Icons.location_city, color: Theme.of(context).primaryColor),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _villageController,
                            decoration: InputDecoration(
                              labelText: 'Village',
                              prefixIcon: Icon(Icons.location_city, color: Theme.of(context).primaryColor),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedCountry,
                            decoration: InputDecoration(
                              labelText: 'Select Country',
                              prefixIcon: Icon(Icons.public, color: Theme.of(context).primaryColor),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            items: _countryValues.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _selectedCountry = value),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedState,
                            decoration: InputDecoration(
                              labelText: 'Select State',
                              prefixIcon: Icon(Icons.map, color: Theme.of(context).primaryColor),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            items: _stateValues.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _selectedState = value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                        prefixIcon: Icon(Icons.location_city, color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _postalCodeController,
                      decoration: InputDecoration(
                        labelText: 'Postal Code',
                        prefixIcon: Icon(Icons.mail, color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _altPhoneController,
                      decoration: InputDecoration(
                        labelText: 'Alternate Phone Number',
                        prefixIcon: Icon(Icons.phone, color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email, color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    if (!widget.isEdit) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password *',
                          prefixIcon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.visibility_off),
                            onPressed: () {
                              // Implement toggle obscureText here if needed
                            },
                          ),
                        ),
                        obscureText: true,
                      ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_validateForm()) {
                          if(widget.isEdit) {
                            context.read<AuthBloc>().add(UpdateProfileEvent(UpdateProfileParams(
                              id: widget.initialData!.id, // Assuming UserEntity has id
                              name: _userNameController.text,
                              addressOne: _address1Controller.text,
                              mobile: _mobileController.text,
                              userType: widget.initialData!.userType,
                              addressTwo: _address2Controller.text,
                              town: _townController.text,
                              village: _villageController.text,
                              country: _selectedCountry,
                              state: _selectedState,
                              city: _cityController.text,
                              postalCode: _postalCodeController.text,
                              altPhone: _altPhoneController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            )));
                          } else {
                            context.read<AuthBloc>().add(SignUpEvent(SignUpParams(
                              name: _userNameController.text,
                              addressOne: _address1Controller.text,
                              mobile: _mobileController.text,
                              userType: widget.initialData!.userType,
                              addressTwo: _address2Controller.text,
                              town: _townController.text,
                              village: _villageController.text,
                              country: _selectedCountry,
                              state: _selectedState,
                              city: _cityController.text,
                              postalCode: _postalCodeController.text,
                              altPhone: _altPhoneController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            )));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        widget.isEdit ? 'Update Profile' : 'Sign Up',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}