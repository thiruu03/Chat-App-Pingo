import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pingo/services/auth/auth_gate.dart';
import 'package:pingo/firebase_options.dart';
import 'package:pingo/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    notificationHandler();
    super.initState();
  }

  void notificationHandler() async {
    // Request Notification Permission
    var status = await Permission.notification.request();

    if (status.isGranted) {
      // If permission is granted, listen for notifications
      FirebaseMessaging.onMessage.listen(
        (event) {
          print("Notification Title: ${event.notification?.title}");
          print("Notification Body: ${event.notification?.body}");
        },
      );
    } else if (status.isDenied || status.isPermanentlyDenied) {
      print("Notification permission denied. Please enable it in settings.");
      // Optionally redirect users to the app settings
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themedata,
    );
  }
}
