import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationService {
  // Instance of the notification plugin
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Firebase Firestore reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Track initialization status
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Initialize the notification service (Android-only support)
  Future<void> initNotification() async {
    if (_isInitialized) return;

    // Android-specific initialization settings
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Combine initialization settings (only Android here)
    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );

    // Initialize the plugin with the settings
    await notificationsPlugin.initialize(initSettings).then((_) {
      _isInitialized = true; // Mark service as initialized
    }).catchError((error) {
      print("Notification initialization failed: $error");
    });
  }

  /// Configure notification details (Android-specific)
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id', // Unique channel ID
        'Daily Notifications', // Channel name
        channelDescription:
            'This channel is for daily notifications.', // Channel description
        importance:
            Importance.max, // High importance for critical notifications
        priority: Priority.high, // High priority
        ticker: 'Daily Notification Ticker', // Optional ticker text
      ),
    );
  }

  /// Show a notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    if (!_isInitialized) {
      await initNotification(); // Ensure the service is initialized
    }
    print(
        'Showing notification with title: $title and body: $body'); // Debug log
    try {
      await notificationsPlugin.show(
        id, // Notification ID (unique per notification)
        title, // Title of the notification
        body, // Body content of the notification
        notificationDetails(), // Notification details
      );
    } catch (error) {
      print("Error showing notification: $error");
    }
  }

  /// Save notification to Firestore
  Future<void> saveNotificationToFirebase({
    required String userId,
    required String title,
    required String body,
    required String date,
  }) async {
    try {
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Notifications')
          .add({
        'title': title,
        'body': body,
        'date': date,
        'read': false, // You can track whether the notification has been read
      });

      print("Notification saved to Firebase");
    } catch (error) {
      print("Error saving notification to Firebase: $error");
    }
  }

  /// Fetch notifications from Firestore
  Future<List<Map<String, dynamic>>> fetchNotificationsFromFirebase({
    required String userId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Notifications')
          .get();
      List<Map<String, dynamic>> notifications = [];

      for (var doc in snapshot.docs) {
        notifications.add(doc.data());
      }

      return notifications;
    } catch (error) {
      print("Error fetching notifications from Firebase: $error");
      return [];
    }
  }

  /// Show and save a notification
  Future<void> notify({
    required String userId,
    String? title,
    String? body,
    required String date,
  }) async {
    // Save notification to Firebase
    await saveNotificationToFirebase(
      userId: userId,
      title: title ?? "New Notification",
      body: body ?? "You have a new message",
      date: date,
    );

    // Trigger local notification
    await showNotification(
      title: title,
      body: body,
    );
  }
}
