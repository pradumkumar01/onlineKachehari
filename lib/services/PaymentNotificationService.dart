import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save payment notification when payment is successful
  Future<void> savePaymentNotification({
    required String amount,
    required String paymentMethod,
    required String transactionId,
    required String status, // "success", "pending", "failed"
    String? advocateName,
    String? serviceType,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        print("No user logged in to save payment notification");
        return;
      }

      final DateTime now = DateTime.now();
      final String formattedDate = now.toIso8601String();

      // Determine title and body based on status
      String title;
      String body;

      switch (status) {
        case 'success':
          title = "Payment Successful";
          body =
              "Payment of ₹$amount for $serviceType has been processed successfully.";
          break;
        case 'pending':
          title = "Payment Pending";
          body = "Your payment of ₹$amount is being processed.";
          break;
        case 'failed':
          title = "Payment Failed";
          body =
              "Payment of ₹$amount failed. Please try again or contact support.";
          break;
        default:
          title = "Payment Update";
          body = "Payment of ₹$amount - $status";
      }

      // Save notification to Firestore
      await _firestore
          .collection('Users')
          .doc(user.uid)
          .collection('Notifications')
          .add({
        'title': title,
        'body': body,
        'date': formattedDate,
        'read': false,
        'type': 'payment', // Mark as payment notification
        'amount': amount,
        'paymentMethod': paymentMethod,
        'transactionId': transactionId,
        'status': status,
        'advocateName': advocateName ?? 'Service Provider',
        'serviceType': serviceType ?? 'Service',
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Payment notification saved successfully for user: ${user.uid}");
    } catch (error) {
      print("Error saving payment notification: $error");
    }
  }

  /// Fetch payment notifications for user
  Future<List<Map<String, dynamic>>> fetchPaymentNotifications({
    required String userId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Notifications')
          .where('type', isEqualTo: 'payment')
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> notifications = [];
      for (var doc in snapshot.docs) {
        notifications.add(doc.data());
      }

      return notifications;
    } catch (error) {
      print("Error fetching payment notifications: $error");
      return [];
    }
  }

  /// Get user-specific notifications (all types)
  Future<List<Map<String, dynamic>>> fetchUserNotifications({
    required String userId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Notifications')
          .orderBy('timestamp', descending: true)
          .limit(50) // Limit to last 50 notifications
          .get();

      List<Map<String, dynamic>> notifications = [];
      for (var doc in snapshot.docs) {
        notifications.add(doc.data());
      }

      return notifications;
    } catch (error) {
      print("Error fetching user notifications: $error");
      return [];
    }
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead({
    required String userId,
    required String notificationId,
  }) async {
    try {
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Notifications')
          .doc(notificationId)
          .update({'read': true});

      print("Notification marked as read");
    } catch (error) {
      print("Error marking notification as read: $error");
    }
  }

  /// Delete notification
  Future<void> deleteNotification({
    required String userId,
    required String notificationId,
  }) async {
    try {
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Notifications')
          .doc(notificationId)
          .delete();

      print("Notification deleted");
    } catch (error) {
      print("Error deleting notification: $error");
    }
  }
}
