import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:flutter_online_kachehari/screens/FeedsPage.dart';
import 'package:flutter_online_kachehari/screens/HomePage.dart';
import 'package:flutter_online_kachehari/screens/UserProfile.dart';
import 'package:flutter_online_kachehari/services/notification_service.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationService notificationService = NotificationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> notifications = [];
  int _selectedIndex = 3;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    notificationService.initNotification();
    _checkUserAndFetchNotifications();
  }

  /// Check if user is logged in, then fetch notifications
  Future<void> _checkUserAndFetchNotifications() async {
    final User? user = _auth.currentUser;

    // Check if user is authenticated
    if (user == null) {
      setState(() => isLoading = false);
      _showLoginRequiredDialog();
      return;
    }

    // Verify user exists in Firestore with retry logic
    final userExists = await _verifyUserExists(user.uid);
    if (!userExists) {
      setState(() => isLoading = false);
      _showInvalidUserDialog();
      return;
    }

    // User is valid, fetch their notifications
    fetchNotifications();
  }

  /// Verify if user exists in Firestore (checks users collection)
  Future<bool> _verifyUserExists(String userId) async {
    try {
      // Check if user document exists in users collection
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        print("User verified: $userId");
        return true;
      }

      // Also check auth user exists
      final authUser = _auth.currentUser;
      if (authUser != null && authUser.uid == userId) {
        print("User authenticated but no Firestore record for: $userId");
        return false;
      }

      return false;
    } catch (e) {
      print("Error verifying user: $e");
      return false;
    }
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Required"),
        content: const Text("Please log in to view notifications."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showInvalidUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("User Not Found"),
        content: const Text(
            "Your user account was not found. Please create a new account or contact support."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// Fetch notifications for the authenticated user
  Future<void> fetchNotifications() async {
    final User? user = _auth.currentUser;

    // Ensure user is still authenticated
    if (user == null) {
      setState(() {
        notifications = [];
        isLoading = false;
      });
      _showLoginRequiredDialog();
      return;
    }

    // Verify user still exists in Firestore
    final userExists = await _verifyUserExists(user.uid);
    if (!userExists) {
      setState(() {
        notifications = [];
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User account not found. Please create an account.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    try {
      // Fetch notifications only for logged-in verified user
      final fetchedNotifications = await notificationService
          .fetchNotificationsFromFirebase(userId: user.uid);

      // Only update if the user is still the same and widget is mounted
      if (mounted && _auth.currentUser?.uid == user.uid) {
        setState(() {
          notifications = fetchedNotifications;
          isLoading = false;
        });
        print(
            "Loaded ${notifications.length} notifications for user: ${user.uid}");
      }
    } catch (error) {
      print("Error fetching notifications: $error");

      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading notifications: $error'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Stack(
          children: [
            const Text("Notifications", style: TextStyle(color: Colors.white)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: const Icon(
                    Icons.notification_add,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  notifications.length.toString(), // Dynamic count
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No Notifications",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "You're all caught up!",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  color: themeData.isDarkMode
                      ? Colors.black
                      : Colors.white.withOpacity(0.8),
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 6.0,
                        ),
                        color: themeData.isDarkMode
                            ? Colors.grey[900]
                            : Colors.white,
                        elevation: 2,
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getNotificationIconColor(
                                      notifications[index]['type'],
                                      notifications[index]['status'])
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getNotificationIcon(notifications[index]['type'],
                                  notifications[index]['status']),
                              color: _getNotificationIconColor(
                                  notifications[index]['type'],
                                  notifications[index]['status']),
                            ),
                          ),
                          title: Text(
                            notifications[index]['title'] ?? "No Title",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: themeData.isDarkMode
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                notifications[index]['body'] ?? "No Content",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: themeData.isDarkMode
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (notifications[index]['type'] ==
                                  'payment') ...[
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Transaction ID: ${notifications[index]['transactionId'] ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                            notifications[index]['status']),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        notifications[index]['status']
                                                ?.toUpperCase() ??
                                            'UNKNOWN',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                notifications[index]['date'] ?? "Unknown Date",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: themeData.isDarkMode
                                      ? Colors.grey[500]
                                      : Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          switch (index) {
            case 0:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
              break;
            case 1:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FeedsPage()));
              break;
            case 3:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationPage()));
              break;
            case 4:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UserProfile()));
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feeds'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  /// Get notification icon based on type
  IconData _getNotificationIcon(String? type, String? status) {
    if (type == 'payment') {
      switch (status) {
        case 'success':
          return Icons.check_circle;
        case 'failed':
          return Icons.error;
        case 'pending':
          return Icons.access_time;
        default:
          return Icons.payment;
      }
    }
    return Icons.notifications_active;
  }

  /// Get icon color based on notification type and status
  Color _getNotificationIconColor(String? type, String? status) {
    if (type == 'payment') {
      return _getStatusColor(status);
    }
    return Colors.deepPurple;
  }

  /// Get status badge color
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'success':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
