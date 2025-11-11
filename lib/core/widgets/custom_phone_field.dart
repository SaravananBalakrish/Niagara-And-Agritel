import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart'; // Keep for countries data; remove full package if extracting data elsewhere

import 'custom_country_picker.dart';

class CustomPhoneField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String initialCountryCode;
  final InputDecoration? decoration;
  final Color? labelColor;
  final Color? textColor;

  const CustomPhoneField({
    super.key,
    this.controller,
    this.initialValue,
    this.initialCountryCode = 'IN',
    this.decoration,
    this.labelColor,
    this.textColor,
  });

  @override
  State<CustomPhoneField> createState() => CustomPhoneFieldState();
}

class CustomPhoneFieldState extends State<CustomPhoneField> {
  late final TextEditingController _effectiveController;
  late final GlobalKey<FormFieldState> _fieldKey;
  late String _countryCode;
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _fieldKey = GlobalKey<FormFieldState>();
    _effectiveController = widget.controller ?? TextEditingController();

    final initialCountry = countries.firstWhere(
          (country) => country.code == widget.initialCountryCode,
      orElse: () => countries.firstWhere((country) => country.code == 'IN'),
    );
    _selectedCountry = initialCountry;
    _countryCode = '+${_selectedCountry.dialCode}';

    if (widget.controller == null && widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      _effectiveController.text = widget.initialValue!;
    }
  }

  void _showCountryPicker() async {
    await CustomCountryPicker.show(
      context: context,
      onCountrySelected: (country) {
        setState(() {
          _selectedCountry = country;
          _countryCode = '+${country.dialCode}';
        });
        _fieldKey.currentState?.didChange(_effectiveController.text);
      },
      initialCountryCode: _selectedCountry.code,
    );
  }

  Widget _buildCountrySelector() {
    return GestureDetector(
      onTap: _showCountryPicker,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 9, horizontal: 2),
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey.shade300)),
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_selectedCountry.flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 4),
            Text(
              _countryCode,
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _effectiveController.dispose();
    }
    super.dispose();
  }

  String get fullPhoneNumber {
    return _countryCode + _effectiveController.text;
  }

  Color _getDefaultColor() {
    return Colors.white;
    return Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid phone number';
    }
    if (_selectedCountry.code == 'IN' && (value.length < 10 || value.length > 10)) {
      return 'Phone number must be 10 digits for India';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Phone number must contain only digits';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final defaultLabelColor = widget.labelColor ?? Colors.white54;
    final defaultTextColor = widget.textColor ?? _getDefaultColor();

    return Row(
      spacing: 2,
      children: [
        _buildCountrySelector(),
        Expanded(
          child: TextFormField(
            key: _fieldKey,
            controller: _effectiveController,
            style: TextStyle(color: defaultTextColor),
            decoration: (widget.decoration ??
                InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: defaultLabelColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  errorStyle: const TextStyle(color: Colors.redAccent),
                ))
                .copyWith(
              labelStyle: (widget.decoration?.labelStyle ??
                  TextStyle(color: defaultLabelColor)),
            ),
            onChanged: (value) {
              setState(() {});
            },
            validator: _validatePhoneNumber,
          ),
        ),
      ],
    );
  }
}