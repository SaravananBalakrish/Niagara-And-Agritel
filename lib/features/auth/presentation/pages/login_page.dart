import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/route_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();

  bool useOtp = true; // Toggle between OTP and password
  int _resendSeconds = 30;
  bool _canResend = true;
  Timer? _timer;

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendSeconds = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthAuthenticated) {
            GoRouter.of(context).go(RouteConstants.dashboard);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Welcome, ${state.user.name}!')),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Mobile Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter mobile number';
                      if (value.length != 10) return 'Mobile number must be 10 digits';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (useOtp)
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'OTP'),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter OTP';
                        if (value.length != 6) return 'OTP must be 6 digits';
                        return null;
                      },
                    )
                  else
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter password';
                        return null;
                      },
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final mobile = _mobileController.text.trim();
                        final password = _passwordController.text.trim();
                        final otp = _otpController.text.trim();

                        BlocProvider.of<AuthBloc>(context).add(
                          LoginEvent(
                            mobileNumber: mobile,
                            password: useOtp ? null : password,
                            otp: useOtp ? otp : null,
                          ),
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 8),
                  if (useOtp)
                    TextButton(
                      onPressed: _canResend
                          ? () {
                        final mobile = _mobileController.text.trim();
                        if (mobile.length == 10) {
                          // Call API to resend OTP here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('OTP resent')),
                          );
                          _startResendTimer();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enter valid mobile number')),
                          );
                        }
                      }
                          : null,
                      child: Text(_canResend ? 'Resend OTP' : 'Resend in $_resendSeconds s'),
                    ),
                  TextButton(
                    onPressed: () {
                      setState(() => useOtp = !useOtp);
                    },
                    child: Text(useOtp ? 'Login with Password' : 'Login with OTP'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
