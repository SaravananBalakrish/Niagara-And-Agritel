import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/flavor/flavor_config.dart';
import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Log the debug token (debug mode only)
  /*await FirebaseAppCheck.instance.activate(
    androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );



  */
  try {
    print("🔍 App Check: Activating with provider ${kDebugMode ? 'debug' : 'playIntegrity'}");
    await FirebaseAppCheck.instance.activate(
      androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.deviceCheck,
    );
    final token = await FirebaseAppCheck.instance.getToken(true);
    if (token != null) {
      print("✅ App Check Token: $token");
    } else {
      print("❌ No App Check Token received");
    }
  } catch (e, stackTrace) {
    print("⚠️ Detailed AppCheck error: $e\nStackTrace: $stackTrace");
  }

  FlavorConfig.setupFromDartDefine();
  await appMain();
}
