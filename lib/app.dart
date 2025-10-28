import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/di/injection.dart' as di;
import 'core/services/notification_service.dart';
import 'core/theme/theme_provider.dart';
import 'core/utils/route_constants.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'routes.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notificationService = di.sl<NotificationService>();
  notificationService.handleBackgroundMessage(message);
}

Future<void> appMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await di.sl<NotificationService>().init();

  runApp(const RootApp());
}

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  final _authBloc = di.sl<AuthBloc>();
  final _themeProvider = di.sl<ThemeProvider>();
  late final AppRouter _router;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _router = AppRouter(authBloc: _authBloc);
    _checkCachedUser();
    // _setupFcm();
  }

  Future<void> _setupFcm() async {
    final fcmToken = await di.sl<NotificationService>().getFcmToken();
    print('FCM Token: $fcmToken');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      di.sl<NotificationService>().showNotification(
        title: message.notification?.title ?? 'App Notification',
        body: message.notification?.body ?? 'You have a new message',
        payload: message.data.toString(),
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened: ${message.data}');
      if (message.data['payload'] == 'otp_sent') {
        _router.router.go(RouteConstants.verifyOtp, extra: {'verificationId': message.data['verificationId'], 'phone': message.data['phone']});
      }
    });
  }

  Future<void> _checkCachedUser() async {
    _authBloc.add(CheckCachedUserEvent());
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeProvider),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            loginWithPassword: di.sl<LoginWithPassword>(),
            sendOtp: di.sl<SendOtp>(),
            verifyOtp: di.sl<VerifyOtp>(),
            logout: di.sl<Logout>(),
            checkPhoneNumber: di.sl<CheckPhoneNumber>(),
            signUp: di.sl<SignUp>(),
            updateProfile: di.sl<UpdateProfile>(),
          )..add(CheckCachedUserEvent()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.theme,
            routerConfig: _router.router,
            /*builder: (context, child) =>
                FlavorBanner(child: child ?? const SizedBox()),*/
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }
}