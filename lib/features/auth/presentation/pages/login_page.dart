import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../core/services/network_info.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/route_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../domain/usecases/login_usecase.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final GlobalKey<FormState> _formKey;
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  String countryCode = '+91';
  String? errorMessage;
  bool isRateLimited = false;
  bool useOtpLogin = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withOpacity(0.9),
              theme.primaryColorDark.withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                print('BlocConsumer listener received state: $state');
                if (state is PhoneNumberChecked) {
                  if (state.exists) {
                    if (useOtpLogin) {
                      context.read<AuthBloc>().add(SendOtpEvent(PhoneParams(state.phone, state.countryCode)));
                    } else {
                      final loginParams = LoginParams(
                        phone: state.phone,
                        password: passwordController.text,
                      );
                      context.read<AuthBloc>().add(LoginWithPasswordEvent(loginParams));
                    }
                  } else {
                    setState(() {
                      errorMessage = 'Phone number not registered. Please sign up.';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Phone number not registered. Please sign up.')),
                    );
                  }
                }
                if (state is OtpSent) {
                  print('Navigating to OTP screen: verificationId=${state.verificationId}, phone=${state.phone}');
                  setState(() {
                    errorMessage = null;
                    isRateLimited = false;
                  });
                }
                if (state is Authenticated) {
                  print('Authenticated: ${state.user.userDetails.mobile}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Welcome ${state.user.userDetails.mobile}"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                  // context.go(RouteConstants.dashboard);
                  context.go(RouteConstants.dealerDashboard);
                }
                if (state is AuthError) {
                  print('AuthError: code=${state.code}, message=${state.message}');
                  setState(() {
                    String displayMessage = state.message;
                    if (state.message.contains('Invalid phone number format')) {
                      displayMessage = 'Invalid phone number format. Please enter a valid number.';
                    } else if (state.message.contains('check-phone-failed')) {
                      displayMessage = 'Failed to verify phone number. Please try again.';
                    } else if (state.message.contains('Login failed')) {
                      displayMessage = 'Invalid password. Please try again.';
                    }
                    errorMessage = displayMessage;
                    if (state.code == 'too-many-requests') {
                      isRateLimited = true;
                      Future.delayed(const Duration(minutes: 2), () {
                        if (mounted) setState(() => isRateLimited = false);
                      });
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage!)),
                  );
                }
              },
              builder: (context, state) {
                print('Builder state: $state');
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: state is AuthLoading
                      ? const Center(
                          key: ValueKey('loading'),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 6,
                          ),
                        )
                      : SingleChildScrollView(
                          key: const ValueKey('form'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 50),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Image.asset(
                                      NiagaraCommonImages.logoLarge,
                                      height: 140,
                                      width: 140,
                                      fit: BoxFit.contain,
                                    ).animate().slideY(
                                          begin: 1,
                                          end: 0,
                                          duration: 1200.ms,
                                          curve: Curves.easeOut,
                                        ).then().shimmer(duration: 2000.ms),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 12.0,
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ).animate().fadeIn(duration: 800.ms),
                              const SizedBox(height: 12),
                              Text(
                                'Sign in to your account',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ).animate().fadeIn(duration: 1000.ms),
                              const SizedBox(height: 48),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        IntlPhoneField(
                                          controller: phoneController,
                                          initialCountryCode: 'IN',
                                          decoration: InputDecoration(
                                            labelText: 'Phone Number',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white.withOpacity(0.9),
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                            prefixIcon: const Icon(Icons.phone, color: Colors.blue),
                                            errorStyle: const TextStyle(color: Colors.redAccent),
                                          ),
                                          onCountryChanged: (country) {
                                            setState(() {
                                              countryCode = '+${country.dialCode}';
                                              errorMessage = null;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null || value.number.isEmpty) {
                                              return 'Please enter a valid phone number';
                                            }
                                            return null;
                                          },
                                        ),
                                        if (!useOtpLogin) ...[
                                          const SizedBox(height: 16),
                                          TextFormField(
                                            controller: passwordController,
                                            decoration: InputDecoration(
                                              labelText: 'Password',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide.none,
                                              ),
                                              filled: true,
                                              fillColor: Colors.white.withOpacity(0.9),
                                              contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 14,
                                              ),
                                              prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                                              errorStyle: const TextStyle(color: Colors.redAccent),
                                            ),
                                            obscureText: true,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter your password';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ).animate().slideY(begin: 0.2, end: 0, duration: 600.ms),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    useOtpLogin = !useOtpLogin;
                                    errorMessage = null;
                                    passwordController.clear();
                                  });
                                },
                                child: Text(
                                  useOtpLogin ? 'Use Password Instead' : 'Use OTP Instead',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ).animate().fadeIn(duration: 1200.ms),
                              if (errorMessage != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ).animate().fadeIn(duration: 500.ms),
                              ],
                              const SizedBox(height: 32),
                              CustomButton(
                                onPressed: isRateLimited
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthBloc>().add(
                                                CheckPhoneNumberEvent(PhoneParams(phoneController.text, countryCode)),
                                              );
                                        }
                                      },
                                text: useOtpLogin ? 'Send OTP' : 'Login',
                                isLoading: state is AuthLoading,
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  context.push(RouteConstants.signUp);
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Not registered? ',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Create an account',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).animate().fadeIn(duration: 1200.ms),
                              if (errorMessage != null && state is AuthError && state.code == 'billing-not-enabled') ...[
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please contact support or check Firebase billing settings.'),
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.all(16),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Contact Support for Billing Issue',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ).animate().fadeIn(duration: 1200.ms),
                              ],
                            ],
                          ),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}