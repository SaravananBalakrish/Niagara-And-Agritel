import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niagara_smart_drip_irrigation/features/mqtt/presentation/bloc/mqtt_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/di/injection.dart' as di;
import 'core/services/notification_service.dart';
import 'core/theme/theme_provider.dart';
import 'routes.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notificationService = di.sl<NotificationService>();
  notificationService.handleBackgroundMessage(message);
}

Future<void> appMain() async {
  await di.init();

  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await di.sl<NotificationService>().init();

  // NEW: Handle initial auth check here to avoid StatefulWidget
  final authBloc = di.sl<AuthBloc>();
  authBloc.add(CheckCachedUserEvent());

  // NEW: Setup FCM (moved from initState)
  /*final fcmToken = await di.sl<NotificationService>().getFcmToken();
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
    // Note: Router access requires context; defer to a listener in widget if needed
    // For simplicity, assume router is accessible via global or BlocListener
  });*/

  runApp(RootApp(authBloc: authBloc));
}

class RootApp extends StatelessWidget {
  final AuthBloc authBloc; // NEW: Pass from appMain
  final ThemeProvider _themeProvider = di.sl<ThemeProvider>();

  RootApp({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeProvider),
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<MqttBloc>(
          lazy: false, // Eager creation
          create: (context) {
            final bloc = di.sl<MqttBloc>();
            return bloc;
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.theme,
            routerConfig: AppRouter(authBloc: authBloc).router,
          );
        },
      ),
    );
  }
}