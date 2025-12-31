import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:flutter_online_kachehari/screens/SplashScreen.dart';
import 'package:flutter_online_kachehari/services/notification_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure proper binding for Firebase
  await Firebase.initializeApp(); // Initialize Firebase

  // init Notification
  NotificationService().initNotification();
  runApp(ChangeNotifierProvider(
      create: (_) => ThemeProviderState(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
